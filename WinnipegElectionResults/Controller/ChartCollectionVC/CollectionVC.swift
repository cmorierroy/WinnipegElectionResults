//
//  CollectionVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-10.
//

import UIKit
import Charts

class CollectionVC: ChartCollectionVC
{
    @IBOutlet weak var navBar: UINavigationItem!
    
    var filter:ElectionData.Filters
    {
        switch(ElectionData.currentFilter)
        {
        case .date: return .area
        case .area: return .date
        default: return .type
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        uniqueAttributes = ElectionData.filterUniqueAttributes(attribute: filter, data: resultsForKey)
        collectionView.reloadData()
    }
        
    override func viewWillAppear(_ animated:Bool)
    {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toDetailVC")
        {
            if let vc = segue.destination as? DetailVC
            {
                let key = sender as! String
                vc.navBar.title = navBar.title!
                vc.chartTitle = key
                vc.results = ElectionData.resultsMatching(key: key, filter: filter, from: resultsForKey)
            }
        }
    }
    
    //MARK: Collection VIEW OVERRIDES
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ChartCell
        
        //SETUP CHART ON CELL
        //MARK: fix
        cell.results = ElectionData.resultsMatching(key: uniqueAttributes[indexPath.row], filter: filter, from: resultsForKey)
        
        //setup pie or bar chart
        if(UserDefaults.standard.string(forKey: "ChartType") == "pie")
        {
            cell.barChart.isHidden = true
            cell.pieChart.isHidden = false
            cell.pieChart.isUserInteractionEnabled = false
            cell.loadPieChart()
        }
        else
        {
            cell.barChart.isHidden = false
            cell.pieChart.isHidden = true
            cell.barChart.isUserInteractionEnabled = false
            cell.loadBarChart()
        }
        
        //SETUP CELL FORMAT
        cell.backgroundColor = .black
        cell.layer.cornerRadius = collectionView.layoutAttributesForItem(at: indexPath)!.size.height/3
        cell.layer.borderWidth = 3
        cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.row)
        
        //MARK: needs adjustment
        var key:String
        
        key = uniqueAttributes[indexPath.row]
        
        performSegue(withIdentifier: "toDetailVC", sender: key)
        //reload to show highlight
        //collectionView.reloadItems(at: [indexPath])
        
        //segue to MLADetailVC
        //performSegue(withIdentifier: "toMLADetailVC", sender: nil)
        
        //delete it from view controller
//        images.remove(at: indexPath.row)
//
//        //delete a image from collection if tapped
//        collectionView.deleteItems(at: [indexPath])
//
//        //MARK: delete image from CoreData
//        let photo = fetchedResultsController.object(at: indexPath)
//        DataController.shared.viewContext.delete(photo)
//        DataController.shared.saveContext()
//
//        updateFetchResultsController()
    }
}
