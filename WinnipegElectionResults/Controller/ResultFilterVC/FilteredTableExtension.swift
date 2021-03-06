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
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
//        switch(ElectionData.currentFilter)
//        {
//        case .date: return "Elections years: \(tableEntries.count)"
//        case .area: return "Election areas: \(tableEntries.count)"
//        default: return "ERROR"
//        }
//    }

    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return tableEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableView.TableDimensions.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView()
        view.backgroundColor = UIColor.AppTheme.paleYellow
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return UITableView.TableDimensions.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.TableDimensions.heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableCell
        
        cell.setupAppearance()
        cell.titleLabel.text = tableEntries[indexPath.section]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let key = tableEntries[indexPath.section]
        performSegue(withIdentifier: "toCollection", sender: key)
    }
}
