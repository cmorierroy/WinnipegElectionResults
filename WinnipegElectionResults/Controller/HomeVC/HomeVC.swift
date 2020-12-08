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
    
    var electionTypes:[ElectionResponse] = []
    
    //MARK: LIFECYCLE FUNCTIONS
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navItem.standardAppearance?.backgroundColor = .black
        navItem.standardAppearance?.shadowColor = .blue
        
        tableView.backgroundColor = UIColor.AppTheme.paleYellow
        
        WODClient.getElections(electionType:"ALL", completion: handleGetElectionTypes(result:error:))
        
    }
    
    //MARK: HELPER FUNCTIONS
    func handleGetElectionTypes(result:[ElectionResponse],error:Error?)
    {
        if let error = error
        {
            print(error)
        }
        else
        {
            //save all the results
            ElectionData.all = result
            
            //extract unique election types
            ElectionData.all = result
            
            for item in result
            {
                if(ElectionData.types.firstIndex(of: item.type) == nil)
                {
                    ElectionData.types.append(item.type)
                }
            }
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "cellTapped")
        {
            if let vc = segue.destination as? ResultFilterVC
            {
                let type = sender as! String
                vc.electionResults = ElectionData.resultsMatching(type:type)
                ElectionData.uniqueDates(data: vc.electionResults)
            }
        }
    }
}
