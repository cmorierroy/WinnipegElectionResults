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
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var fetchedResultsController:NSFetchedResultsController<Favorite>!
    var favorites:[Favorite]? = nil
    var dataMatches:[[ElectionResponse]] = []
    var uniqueKeys:[ResultKey] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        updateFavorites()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated:Bool)
    {
        super.viewWillAppear(animated)
        
        updateFavorites()
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toDetailVC")
        {
            if let vc = segue.destination as? DetailVC
            {
                //MARK: give key along with matching data
                let key = sender as! ResultKey
                
                vc.key = key
                vc.results = ElectionData.resultsMatching(type: key.type, date: key.date, area: key.area)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return uniqueKeys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
            
        //SETUP TITLES ON CELL
        cell.titleLabel?.text = uniqueKeys[indexPath.row].area
        cell.titleLabel?.textColor = UIColor.AppTheme.paleYellow
        cell.dateLabel?.text = uniqueKeys[indexPath.row].date
        cell.dateLabel?.textColor = UIColor.AppTheme.paleYellow
        cell.typeLabel?.text = uniqueKeys[indexPath.row].type
        cell.typeLabel?.textColor = UIColor.AppTheme.paleYellow
        
        //SETUP CHART ON CELL
        cell.results = dataMatches[indexPath.row]
        
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
        //MARK: ADJUST CELL TO HAVE SEPARATE KEY VALUES
        var key:ResultKey
        
        key = uniqueKeys[indexPath.row]
        
        performSegue(withIdentifier: "toDetailVC", sender: key)
    }
    
    func getFavoriteKeys(favorites:[Favorite]?) -> [ResultKey]
    {
        var keys:[ResultKey] = []
        
        if let favorites = favorites
        {
            for item in favorites
            {
                let type = item.type ?? ""
                let date = item.date ?? ""
                let area = item.area ?? ""
                let key = ResultKey(type: type, date: date, area: area)
                keys.append(key)
            }
        }
        
        return keys
    }
    
    func updateFavorites()
    {
        dataMatches = []

        if let favorites = getFavorites()
        {
            uniqueKeys = getFavoriteKeys(favorites:favorites)
            
            //retrieve all results that match given favourites
            for item in favorites
            {
                dataMatches.append(ElectionData.resultsMatching(type: item.type ?? "", date: item.date ?? "", area: item.area ?? ""))
            }
        }
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
