//
//  HomeVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-11-30.
//

import UIKit
import CoreData

class HomeVC: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    var fetchedResultsController:NSFetchedResultsController<LastUpdate>!

    var tableEntries:[String] = []
    
    //MARK: LIFECYCLE FUNCTIONS
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        
        navItem.standardAppearance?.backgroundColor = .black
        navItem.standardAppearance?.shadowColor = .blue
        
        tableView.isHidden = true
        activityIndicator.startAnimating()
        
        updateDateLabel.text = "Last updated: "
        
        WODClient.getElections(electionType:"ALL", completion: handleGetElectionTypes(result:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: COREDATA
    fileprivate func setupFetchedResultsController()
    {
        let fetchRequest: NSFetchRequest<LastUpdate> = LastUpdate.fetchRequest()
        fetchRequest.sortDescriptors = []

       fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "lastUpdate")

    }
    
    func getLastUpdate() -> LastUpdate?
    {
        var lastUpdate:LastUpdate? = nil
        
        do
        {
            try fetchedResultsController.performFetch()

            //get the only last update object (needs to be coded better)
            if let objects = fetchedResultsController.fetchedObjects
            {
                if(objects.count > 0)
                {
                    lastUpdate = objects[0]
                }
            }
            
        }
        catch
        {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        return lastUpdate
    }
    
    //MARK: HELPER FUNCTIONS
    func handleGetElectionTypes(result:[ElectionResponse],error:Error?)
    {
        
        //setup date formatter
        var currentFormattedDate = ""
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        
        let lastUpdate:LastUpdate? = getLastUpdate()
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ElectionResult.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "fullDate", ascending: false)
        let sortByArea = NSSortDescriptor(key:"area", ascending: true)
        fetchRequest.sortDescriptors = [sortByDate,sortByArea]
        
        if let error = error
        {
            displayAlert(title: "Error", message: error.localizedDescription)
                        
            if let date = lastUpdate?.date
            {
                currentFormattedDate = formatter.string(from: date)
            }
            else
            {
                currentFormattedDate = "N/A"
            }
            
            //create array from coredata entries if they exist
            var items:[ElectionResponse] = []
            
            do
            {
                let fetchedEntries = try DataController.shared.viewContext.fetch(fetchRequest) as! [ElectionResult]
                
                var item:ElectionResponse
                for entry in fetchedEntries
                {
                    let fullDate = entry.fullDate ?? ""
                    let type = entry.type ?? ""
                    let area = entry.area ?? ""
                    let candidate = entry.candidate ?? ""
                    let position = entry.position ?? ""
                    let votes = entry.votes ?? ""
                    let won = entry.won ?? ""
                    
                    item = ElectionResponse(fullDate: fullDate, type: type, area: area, candidate: candidate, position: position, votes: votes, won: won)
                    items.append(item)
                }
                
                ElectionData.all = items
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
        }
        else
        {
            //save all the results
            //wipe all previous coredata electionResults
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            // perform the delete
            do
            {
                try DataController.shared.viewContext.execute(deleteRequest)
            }
            catch let error as NSError
            {
                print(error)
            }
            
            //place all new entries from result in coredata, in case internet unavailable
            for item in result
            {
                let entry = ElectionResult(context:DataController.shared.viewContext)
                entry.won = item.won
                entry.candidate = item.candidate
                entry.area = item.area
                entry.type = item.type
                entry.fullDate = item.fullDate
                entry.position = item.position
                entry.votes = item.votes
            }
            
            //save all requested data to be used as current data
            ElectionData.all = result
            
            //MARK: future improvement
            //ElectionData.filterBallotQuestions() //create a separate JSON object for any ballot questions
            //TODO: probably best to divide wards/school divisions/ballot questions
            
            
            let currentDate = Date()
            currentFormattedDate = formatter.string(from: currentDate)
            
            //update last update
            if let date = lastUpdate
            {
                //if not nil, assign current date
                date.date = Date()
            }
            else
            {
                //create new date object
                let newUpdate = LastUpdate(context: DataController.shared.viewContext)
                newUpdate.date = Date()
            }
            
            //save context
            DataController.shared.saveContext()
        }
        
        tableEntries = ElectionData.filterUniqueAttributes(attribute: .type, data: ElectionData.all)
        tableView.reloadData()
        
        //set text
        updateDateLabel.text = updateDateLabel.text! + currentFormattedDate
        
        activityIndicator.stopAnimating()
        tableView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "cellTapped")
        {
            if let vc = segue.destination as? ResultFilterVC
            {
                let type = sender as! String
                vc.key = ResultKey(type: type, date: "", area: "")
                vc.electionResults = ElectionData.resultsMatching(key: type, filter: .type, from: ElectionData.all)
            }
        }
    }
}
