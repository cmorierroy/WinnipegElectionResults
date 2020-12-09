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
        switch(ElectionData.currentFilter)
        {
        case .date: return "Elections years: \(uniqueAttributes.count)"
        case .area: return "Election areas: \(uniqueAttributes.count)"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") ////as! CustomTableCell
        
        //cell.titleLabel.text = ElectionData.dates[indexPath.row]
        //cell.titleLabel.textColor = UIColor.AppTheme.paleYellow
        
        //set cell text
        cell!.textLabel?.text = uniqueAttributes[indexPath.row]
        
        //CELL APPEARANCE
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
        let key = uniqueAttributes[indexPath.row]
        performSegue(withIdentifier: "toLayer2", sender: key)
    }
}
