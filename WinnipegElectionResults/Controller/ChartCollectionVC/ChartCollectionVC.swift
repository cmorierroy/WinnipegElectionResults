//
//  ChartCollectionVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-15.
//

import UIKit

class ChartCollectionVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let cellsPerRow:CGFloat = 2
    let collectionViewInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    var uniqueAttributes:[String] = []
    var resultsForKey:[ElectionResponse] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
        
    override func viewWillAppear(_ animated:Bool)
    {
        super.viewWillAppear(animated)
    }

}

//MARK: Flow Layout
extension ChartCollectionVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return collectionViewInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return collectionViewInsets.bottom
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return collectionViewInsets.right
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding = cellsPerRow * collectionViewInsets.left + collectionViewInsets.right
        let totalWidth = (view.bounds.width - padding)
        let itemWidth = totalWidth / cellsPerRow
        let itemSize = CGSize(width: itemWidth, height: itemWidth)

        return itemSize
  }
}

//MARK: Delegate and Data source
extension ChartCollectionVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chartCell", for: indexPath) as! ChartCell
        
        //SETUP TITLE ON CELL
        cell.titleLabel?.text = uniqueAttributes[indexPath.row]
        cell.titleLabel?.textColor = UIColor.AppTheme.paleYellow
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return uniqueAttributes.count
    }
}
