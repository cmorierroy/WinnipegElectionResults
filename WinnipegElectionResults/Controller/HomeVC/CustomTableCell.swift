//
//  CustomTableCell.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-01.
//

import Foundation
import UIKit

class CustomTableCell : UITableViewCell
{
    var titleLabel: UILabel = UILabel()
    
    func createLabelConstraints()
    {
        //Constraints
        //#1: Turn off autoresizingmask
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        //#2: Create constraints
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        constraints.append(titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
               
        //#3: Activate constraints
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupAppearance()
    {
        //Title label appearance and constraints
        createLabelConstraints()
        
        //Label Appearance
        titleLabel.textColor = UIColor.AppTheme.paleYellow
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        
        //create cell margins
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                
        //'ROW' background
        backgroundColor = UIColor.AppTheme.paleYellow
        
        //'Cell' background
        contentView.layer.backgroundColor = CGColor(gray: 0.0, alpha: 0.4)
        contentView.layer.cornerRadius = 25
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)

        //'Selected Cell' background
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        selectedBackgroundView = backgroundView
        selectedBackgroundView?.layer.cornerRadius = 25
    }
}
