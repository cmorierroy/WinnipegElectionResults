//
//  CollectionVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-10.
//

import UIKit
import Charts

class ChartCell : UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    
    var results:[ElectionResponse] = []
    
    func loadPieChart()
    {
        var dataPoints:[String] = []
        var values:[Double] = []
        
        //get names of people running and amount of votes obtained
        for item in results
        {
            dataPoints.append(item.candidate)
            values.append(Double(item.votes)!)
        }
        
        //Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count
        {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        //Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        //Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartData.setValueTextColor(.clear)
        
        //Assign it to the chart’s data
        
        //CUSTOMIZATION OF PIE CHART
        pieChart.entryLabelColor = .black
        pieChart.centerText = "Democratic score:..."
        pieChart.holeColor = UIColor.AppTheme.paleYellow
        pieChart.data = pieChartData
        pieChart.backgroundColor = UIColor.AppTheme.paleYellow
        
        //customize legend
        pieChart.legend.textColor = .black
        pieChart.legend.setCustom(entries: [])
        pieChart.drawEntryLabelsEnabled = false
        
        //customize center text/labels
        
        
        pieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    func loadBarChart()
    {
        var dataPoints:[String] = []
        var values:[Double] = []
        
        //get names of people running and amount of votes obtained
        for item in results
        {
            dataPoints.append(item.candidate)
            values.append(Double(item.votes)!)
        }
        
        //Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        //Generate random colors for chart
        let chartColors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        //Create legend entries
        var legendEntries:[LegendEntry] = []
        for i in 0 ..< dataPoints.count
        {
            let entry = LegendEntry(label: dataPoints[i], form: Legend.Form.circle, formSize: 10, formLineWidth: 1, formLineDashPhase: 1, formLineDashLengths: nil, formColor: chartColors[i])
            legendEntries.append(entry)
        }

//        barChart.legend.setCustom(entries: legendEntries)
        barChart.legend.setCustom(entries: [])

        
        //Set ChartDataSet
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        barChartDataSet.colors = chartColors
        
        //Set ChartData
        let barChartData = BarChartData(dataSet: barChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        barChartData.setValueFormatter(formatter)
        barChartData.setValueTextColor(.black)
        
        //Assign it to the chart’s data
        
        //CUSTOMIZATION OF PIE CHART
        //barChart.entryLabelColor = .black
        //pieChart.centerText = "Democratic score:..."
        //pieChart.holeColor = UIColor.AppTheme.paleYellow
        barChart.data = barChartData
        barChart.backgroundColor = UIColor.AppTheme.paleYellow
        
        //customize legend
        barChart.legend.textColor = .black
        
        //animate chart
        barChart.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    //randomizes colors for pie chart
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor]
    {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    
}

class CollectionVC: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var navBar: UINavigationItem!
    
    let cellsPerRow:CGFloat = 2
    let collectionViewInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    var uniqueAttributes:[String] = []
    var resultsForKey:[ElectionResponse] = []
    
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
}

//MARK: Delegate and Data source
extension CollectionVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return uniqueAttributes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chartCell", for: indexPath) as! ChartCell

        //SETUP TITLE ON CELL
        cell.titleLabel?.text = uniqueAttributes[indexPath.row]
        
        //SETUP CHART ON CELL
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
        cell.backgroundColor = .red
        cell.layer.cornerRadius = collectionView.layoutAttributesForItem(at: indexPath)!.size.height/3
        cell.layer.borderWidth = 3
        cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
//        cell.image?.image = member.image
//        cell.image?.layer.cornerRadius = 50
//        cell.image?.layer.borderWidth = 10
//        cell.image?.layer.borderColor = MLAData.colorOfParty(party: member.party)
//        //cell.backgroundView
//        cell.nameLabel?.text = member.name
//        cell.constituencyLabel?.text = member.constituency
//        cell.partyLabel?.text = member.party
//
//        if(cell.isSelected)
//        {
//            //create white highlight to indicate selection
//            cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        }
//        else
//        {
//            cell.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//        }
//        cell.layer.cornerRadius = 20
        //cell.layer.borderColor = UIColor()
        //cell.backgroundColor = MLAData.colorOfParty(party: member.party)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.row)
        
        //MARK: needs adjustment
        var key:String
        
        key = uniqueAttributes[indexPath.row]
//        switch(ElectionData.currentFilter)
//        {
//        case .date: key = resultsForKey[indexPath.row].area
//        case .area: key = resultsForKey[indexPath.row].date
//        }
        
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

//MARK: Flow Layout
extension CollectionVC : UICollectionViewDelegateFlowLayout
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
