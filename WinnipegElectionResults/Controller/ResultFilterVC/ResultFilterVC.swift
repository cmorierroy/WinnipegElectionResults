//
//  ResultFilterVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-02.
//

import UIKit

class ResultFilterVC: UIViewController
{

    @IBOutlet weak var segControlView: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var electionResults:[ElectionResponse] = []
    var uniqueAttributes:[String] = []
    
    var segmentedControlSelectionIndex:Int
    {
        return segControlView.selectedSegmentIndex
    }
    
    //MARK: LIFECYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //when first loading view, default to date filter
        ElectionData.currentFilter = .date
        
        //reload data for table, default to dates filter
        uniqueAttributes = ElectionData.filterUniqueAttributes(attribute: ElectionData.currentFilter, data: electionResults)
        
        tableView.reloadData()
        
        //set up action for segmented control view
        segControlView.addTarget(self, action: #selector(changeFilter), for: .valueChanged)
    }
    
    //MARK: Segmented Control Action
    //flip-flop between viewing election years or areas based on segmentedControl index selected
    @objc func changeFilter()
    {
        if(segmentedControlSelectionIndex == 0)
        {
            ElectionData.currentFilter = ElectionData.Filters.date
        }
        else
        {
            ElectionData.currentFilter = ElectionData.Filters.area
        }
        
        uniqueAttributes = ElectionData.filterUniqueAttributes(attribute: ElectionData.currentFilter, data: electionResults)
        tableView.reloadData()

    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toLayer2")
        {
            if let vc = segue.destination as? Layer2FilterVC
            {
                let key = sender as! String
                vc.resultsForKey = ElectionData.resultsMatching(key: key, filter: ElectionData.currentFilter, from: electionResults)
            }
        }
    }

}
