//
//  Layer2FilterVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-02.
//

import UIKit

class Layer2FilterVC: UIViewController
{
    
    @IBOutlet weak var tableView: UITableView!
    
    var filter:ElectionData.Filters
    {
        switch(ElectionData.currentFilter)
        {
        case .date: return .area
        case .area: return .date
        }
    }
    
    var uniqueAttributes:[String] = []
    var resultsForKey:[ElectionResponse] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        uniqueAttributes = ElectionData.filterUniqueAttributes(attribute: filter, data: resultsForKey)
        tableView.reloadData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toDetailVC")
        {
            if let vc = segue.destination as? DetailVC
            {
                let key = sender as! String
                vc.chartTitle = key

                vc.results = ElectionData.resultsMatching(key: key, filter: filter, from: resultsForKey)
            }
        }
    }
}

extension Layer2FilterVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch(filter)
        {
        case .area: return "Areas: \(uniqueAttributes.count)"
        case .date: return "Years: \(uniqueAttributes.count)"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return uniqueAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filter2Cell") //as! CustomTableCell
        
        cell!.textLabel?.text = uniqueAttributes[indexPath.row]
//        switch(ElectionData.currentFilter)
//        {
//        case .date: cell!.textLabel?.text = resultsForKey[indexPath.row].area
//        case .area: cell!.textLabel?.text = resultsForKey[indexPath.row].date
//        }
        
        cell!.textLabel?.textColor = UIColor.AppTheme.paleYellow

        cell!.contentView.backgroundColor = .black
        cell!.contentView.layer.cornerRadius = 10
        cell!.contentView.layer.borderWidth = 3
        cell!.contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        cell!.backgroundColor = UIColor.AppTheme.paleYellow

        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //MARK: needs adjustment
        var key:String
        
        key = uniqueAttributes[indexPath.row]
//        switch(ElectionData.currentFilter)
//        {
//        case .date: key = resultsForKey[indexPath.row].area
//        case .area: key = resultsForKey[indexPath.row].date
//        }
        
        performSegue(withIdentifier: "toDetailVC", sender: key)
    }
}
