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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ElectionData.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableCell
        
        cell.titleLabel.text = ElectionData.types[indexPath.row]
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        cell.backgroundColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let type = ElectionData.types[indexPath.row]
        performSegue(withIdentifier: "cellTapped", sender: type)
    }
}
