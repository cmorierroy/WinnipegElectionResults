//
//  ViewController.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-11-30.
//

import UIKit
import Alamofire

class ViewController: UIViewController
{
    var allData = [ElectionResponse]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //WODClient.getElections(Endpoints.getGeneralElections.url, completion: handleGeneralElections(result:error:))
        
        AF.request(WODClient.Endpoints.getGeneralElections.url).response
        {
            response in
            if let data = response.data
            {
                let decoder = JSONDecoder()
                do
                {
                    self.allData = try decoder.decode([ElectionResponse].self, from: data)
                    DispatchQueue.main.async
                    {
                        //print(self.allData)
                        var types:[String] = []
                        var match:Bool
                        
                        for item in self.allData
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
                catch
                {
                    DispatchQueue.main.async
                    {
                        print(error)
                    }
                }
            }
        }
        
        
    }
}
