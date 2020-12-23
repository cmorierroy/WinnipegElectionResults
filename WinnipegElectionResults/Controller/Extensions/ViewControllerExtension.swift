//
//  ViewControllerExtension.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-22.
//

import Foundation
import UIKit

extension UIViewController
{
    func displayAlert(title: String, message: String)
    {
        DispatchQueue.main.async
        {
            let alertVC = UIAlertController(title:title,message: message,preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.showDetailViewController(alertVC, sender: nil)
        }
    }
}
