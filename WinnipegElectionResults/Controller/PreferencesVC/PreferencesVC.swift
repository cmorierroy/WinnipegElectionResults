//
//  PreferencesVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-09.
//

import UIKit

class PreferencesVC: UIViewController {

    @IBOutlet weak var chartTypeControl: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //chartTypeControl
        //set up action for segmented control view
        chartTypeControl.addTarget(self, action: #selector(changeChartType), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(UserDefaults.standard.string(forKey: "ChartType") == "pie")
        {
            chartTypeControl.selectedSegmentIndex = 0
        }
        else
        {
            chartTypeControl.selectedSegmentIndex = 1
        }
    }
    
    @objc func changeChartType()
    {
        if(chartTypeControl.selectedSegmentIndex == 0)
        {
            UserDefaults.standard.set("pie", forKey: "ChartType") //switch to pie
        }
        else
        {
            UserDefaults.standard.set("bar", forKey: "ChartType") //switch to bar
        }
        
    }

}
