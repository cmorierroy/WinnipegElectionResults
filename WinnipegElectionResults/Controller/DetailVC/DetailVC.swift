//
//  DetailVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-03.
//

import UIKit
import Charts
import CoreData

class DetailVC: UIViewController
{
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var chartTitle:String = ""
    var key:ResultKey = ResultKey(type: "", date: "", area: "")
    var results:[ElectionResponse] = []
    var favorite:Favorite? = nil
    
    func retrieveResultFromCoreData() -> Favorite?
    {
        //remove from favourites
        //        //MARK: delete image from CoreData
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let typePredicate = NSPredicate(format:"type = %@", key.type)
        let datePredicate = NSPredicate(format:"date = %@", key.date)
        let areaPredicate = NSPredicate(format:"area = %@", key.area)
        
        var subPredicates:[NSPredicate] = []
        subPredicates.append(typePredicate)
        subPredicates.append(datePredicate)
        subPredicates.append(areaPredicate)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        fetchRequest.sortDescriptors = []
        
        do
        {
            let result = try DataController.shared.viewContext.fetch(fetchRequest)
            
            if result.count > 0
            {
                return result[0]
            }
            else
            {
                return nil
            }
        }
        catch
        {
            print("Error in DetailVC retrieveResultFromCoreData")
            return nil
        }
    }
    
    @IBAction func favButtonPressed(_ sender: Any)
    {
        if(favouriteButton.isSelected)
        {
            print("removing from favorites...\(key.date),\(key.type),\(key.area)")
            if let favorite = favorite
            {
                DataController.shared.viewContext.delete(favorite)
            }

        }
        else
        {
            //add to favourites
            print("adding to favourites...\(key.date),\(key.type),\(key.area)")
            let favorite = Favorite(context: DataController.shared.viewContext)
            favorite.date = key.date
            favorite.type = key.type
            favorite.area = key.area
        }
        
        //save context
        DataController.shared.saveContext()
        
        //toggle button to opposite state
        favouriteButton.isSelected = !favouriteButton.isSelected
    }
    
    //MARK: LIFECYCLE f(x)s
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        favorite = retrieveResultFromCoreData()
        
        setupFavoriteButton()
        
        switch(ElectionData.currentFilter)
        {
        case .area:
            navBar.title = key.type + " | " + key.area
            subTitle.text = key.date
        case .date:
            navBar.title = key.type + " | " + key.date
            subTitle.text = key.area
        default: print("Error in DetailVC viewDidLoad()")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if(UserDefaults.standard.string(forKey: "ChartType") == "pie")
        {
            barChart.isHidden = true
            pieChart.isHidden = false
            loadPieChart()
            pieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        }
        else
        {
            barChart.isHidden = false
            pieChart.isHidden = true
            loadBarChart()
            barChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        }
    }
    
    func setupFavoriteButton()
    {
        //set image for states
        favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favouriteButton.setImage(UIImage(systemName:"star"), for: .normal)
        
        //Favourite button customization
        favouriteButton.layer.borderWidth = 1
        favouriteButton.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        favouriteButton.backgroundColor = UIColor(cgColor: CGColor(gray: 0, alpha: 0.2))
        //favouriteButton.layer.cornerRadius = favouriteButton.frame.height/3
        favouriteButton.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        favouriteButton.layer.masksToBounds = false
        favouriteButton.layer.shadowRadius = 5
        favouriteButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        favouriteButton.layer.shadowOpacity = 1
        
        if favorite != nil
        {
            favouriteButton.isSelected = true
        }
        else
        {
            favouriteButton.isSelected = false
        }
    }
    
    //MARK: PIE CHART f(x)s
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
        pieChartDataSet.colors = UIColor.generateRandomColors(numbersOfColor: dataPoints.count)
        
        //Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartData.setValueTextColor(.black)
        
        //Assign it to the chart’s data
        
        //CUSTOMIZATION OF PIE CHART
        pieChart.entryLabelColor = .black
        pieChart.centerText = "Democratic score:..."
        pieChart.holeColor = UIColor.AppTheme.paleYellow
        pieChart.data = pieChartData
        pieChart.backgroundColor = UIColor.AppTheme.paleYellow
        
        //customize legend
        pieChart.legend.textColor = .black
    }
    
    //MARK: BAR CHART f(x)s
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
        let chartColors = UIColor.generateRandomColors(numbersOfColor: dataPoints.count)
        
        //Create legend entries
        var legendEntries:[LegendEntry] = []
        for i in 0 ..< dataPoints.count
        {
            let entry = LegendEntry(label: dataPoints[i], form: Legend.Form.circle, formSize: 10, formLineWidth: 1, formLineDashPhase: 1, formLineDashLengths: nil, formColor: chartColors[i])
            legendEntries.append(entry)
        }

        barChart.legend.setCustom(entries: legendEntries)
        
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
    }
}
