//
//  ResultFilterVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-02.
//

import UIKit

class ResultFilterVC: UIViewController
{

    var electionResults:[ElectionResponse] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toLayer2")
        {
            if let vc = segue.destination as? Layer2FilterVC
            {
                let date = sender as! String
                vc.resultsForYear = ElectionData.resultsMatching(date: date, from: electionResults)
                ElectionData.uniqueWards(data:vc.resultsForYear)
            }
        }
    }

}
