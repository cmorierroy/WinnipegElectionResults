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
    @IBOutlet weak var navBar: UINavigationItem!
    
    var electionResults:[ElectionResponse] = []
    var tableEntries:[String] = []
    var key:ResultKey = ResultKey(type: "", date: "", area: "")
    
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
        
        navBar.title = key.type + "s"
        
        //reload data for table, default to dates filter
        tableEntries = ElectionData.filterUniqueAttributes(attribute: ElectionData.currentFilter, data: electionResults)
        
        tableView.reloadData()
        
        //set up action for segmented control view
        segControlView.addTarget(self, action: #selector(changeFilter), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        
        tableEntries = ElectionData.filterUniqueAttributes(attribute: ElectionData.currentFilter, data: electionResults)
        tableView.reloadData()

    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toCollection")
        {
            if let vc = segue.destination as? CollectionVC
            {
                let value = sender as! String
                switch(ElectionData.currentFilter)
                {
                case .area: key.area = value
                case .date: key.date = value
                case .type: print("Error: filter problem in ResultFilter prepare()")
                }
    
                vc.key = key
                vc.resultsForKey = ElectionData.resultsMatching(key: value, filter: ElectionData.currentFilter, from: electionResults)
            }
        }
    }

}
