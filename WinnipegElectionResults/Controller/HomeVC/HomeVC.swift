//
//  HomeVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-11-30.
//

import UIKit

class HomeVC: UIViewController
{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tableEntries:[String] = []
    
    //MARK: LIFECYCLE FUNCTIONS
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navItem.standardAppearance?.backgroundColor = .black
        navItem.standardAppearance?.shadowColor = .blue
        
        tableView.isHidden = true
        activityIndicator.startAnimating()
        
        WODClient.getElections(electionType:"ALL", completion: handleGetElectionTypes(result:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: HELPER FUNCTIONS
    func handleGetElectionTypes(result:[ElectionResponse],error:Error?)
    {
        
        if let error = error
        {
            displayAlert(title: "Error", message: error.localizedDescription)
        }
        else
        {
            //save all the results
            ElectionData.all = result
            ElectionData.filterBallotQuestions() //create a separate JSON objects for any ballot questions
            //TODO: probably best to divide wards from school divisions from ballot questions
            
            tableEntries = ElectionData.filterUniqueAttributes(attribute: .type, data: ElectionData.all)
            tableView.reloadData()
        }
        
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
                vc.navBar.title = type + "s"
                vc.electionResults = ElectionData.resultsMatching(key: type, filter: .type, from: ElectionData.all)
            }
        }
    }
    
    func displayAlert(title: String, message: String)
    {
        DispatchQueue.main.async
        {
            let alertVC = UIAlertController(title:title,message: message,preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.showDetailViewController(alertVC, sender: nil)
        }
    }
}
