//
//  Layer2FilterVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-02.
//

import UIKit

class Layer2FilterVC: UIViewController
{
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultsForYear:[ElectionResponse] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toDetailVC")
        {
            if let vc = segue.destination as? DetailVC
            {
                let ward = sender as! String
                vc.chartTitle = ward
                vc.results = ElectionData.resultsMatching(ward: ward, from: resultsForYear)
            }
        }
    }
}

extension Layer2FilterVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Areas: \(ElectionData.wards.count)"
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
        return ElectionData.wards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filter2Cell") //as! CustomTableCell
        
        cell!.textLabel?.text = ElectionData.wards[indexPath.row]
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
        let ward = ElectionData.wards[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: ward)
    }
}
