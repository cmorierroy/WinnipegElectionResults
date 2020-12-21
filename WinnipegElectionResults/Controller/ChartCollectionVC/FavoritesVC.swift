//
//  FavoriesVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-13.
//

import UIKit
import CoreData

class FavoritesVC: ChartCollectionVC
{
    var fetchedResultsController:NSFetchedResultsController<Favorite>!
    var favorites:[Favorite]? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        
        //MARK: get attributes from coredata (title)
        favorites = getFavorites()
        uniqueAttributes = getFavoriteTitles(favorites:favorites)
        
        //retrieve all results that match given favourites
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated:Bool)
    {
        super.viewWillAppear(animated)
        favorites = getFavorites()
        uniqueAttributes = getFavoriteTitles(favorites:favorites)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ChartCell
        
        //SETUP CHART ON CELL
        //MARK: GET DATA FROM COREDATA?
        cell.results = []//ElectionData.resultsMatching(key: uniqueAttributes[indexPath.row], filter: filter, from: resultsForKey)
        
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
        //MARK: needs adjustment
        var key:String
        
        key = uniqueAttributes[indexPath.row]
        
        performSegue(withIdentifier: "toDetailVC", sender: key)
        //reload to show highlight
        //collectionView.reloadItems(at: [indexPath])
    }
    
    func getFavoriteTitles(favorites:[Favorite]?) -> [String]
    {
        var titles:[String] = []
        
        if let favorites = favorites
        {
            
            for item in favorites
            {
                let type = item.type ?? ""
                let date = item.date ?? ""
                let area = item.area ?? ""
                titles.append(type + " | " + date + " | " + area)
            }
            
        }
        
        return titles
    }
    
    //MARK: COREDATA
    fileprivate func setupFetchedResultsController()
    {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.sortDescriptors = []

       fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "favorites")

    }
    
    func getFavorites() -> [Favorite]?
    {
        var favorites:[Favorite]? = nil
        
        do
        {
            try fetchedResultsController.performFetch()

            //get the only last update object (needs to be coded better)
            if let objects = fetchedResultsController.fetchedObjects
            {
                favorites = objects
            }
        }
        catch
        {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        return favorites
    }
    
}
