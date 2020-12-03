//
//  FilteredTableExtension.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-02.
//

import Foundation
import UIKit

extension ResultFilterVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Results: \(ElectionData.dates.count)"
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
        return ElectionData.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") //as! CustomTableCell
        
        cell!.textLabel?.text = ElectionData.dates[indexPath.row]
        cell!.textLabel?.textColor = .white
        
        cell!.contentView.layer.cornerRadius = 10
        cell!.contentView.layer.borderWidth = 3
        cell!.contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        cell!.backgroundColor = .black
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let date = ElectionData.dates[indexPath.row]
        performSegue(withIdentifier: "toLayer2", sender: date)
    }
}
