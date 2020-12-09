//
//  TableViewExtension.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-01.
//

import Foundation
import UIKit

extension HomeVC : UITableViewDelegate, UITableViewDataSource
{
    //MARK: Sections and headers
    func numberOfSections(in tableView: UITableView) -> Int
    {
        ElectionData.types.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView()
        view.backgroundColor = UIColor.AppTheme.paleYellow
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableCell
                
        cell.titleLabel.text = ElectionData.types[indexPath.section] + "s"
        
        cell.contentView.layer.cornerRadius = 25
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        
        cell.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        cell.backgroundColor = UIColor.AppTheme.paleYellow
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let type = ElectionData.types[indexPath.section]
        performSegue(withIdentifier: "cellTapped", sender: type)
    }
}
