//
//  ViewController.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-11-30.
//

import UIKit

class ViewController: UIViewController
{    
    //MARK: LIFECYCLE FUNCTIONS
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        WODClient.getElections(electionType:"ALL", completion: handleGetElectionTypes(result:error:))
        
    }
    
    //MARK: HELPER FUNCTIONS
    func handleGetElectionTypes(result:[ElectionResponse],error:Error?)
    {
        if let error = error
        {
            print(error)
        }
        else
        {
            var types:[String] = []
            var match:Bool
            
            for item in result
            {
                match = false
                for entry in types
                {
                    if item.type == entry
                    {
                        match = true
                    }
                }
                
                if !match
                {
                    types.append(item.type)
                }
            }
            print(types)
        }
    }
}
