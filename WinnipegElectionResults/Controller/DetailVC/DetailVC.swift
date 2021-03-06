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
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var chartTitle:String = ""
    var key:ResultKey = ResultKey(type: "", date: "", area: "")
    var results:[ElectionResponse] = []
    var favorite:Favorite? = nil
    
    //MARK: IBACTIONS
    @IBAction func shareButtonPressed(_ sender: Any)
    {
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: false)
        let chartImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let controller = UIActivityViewController(activityItems:[chartImage], applicationActivities: nil)
                
        controller.completionWithItemsHandler =
            {
                (activity, success, items, error) in
                if success
                {
                    print("success")
                }
            }
        
        //pop up controller
        present(controller, animated: true, completion: nil)
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
        setupShareButton()
        
        navBar.title = "Results For:"
        
        areaLabel.text = key.area
        dateLabel.text = key.date
        typeLabel.text = key.type
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
    
    func setupShareButton()
    {
        //Favourite button customization
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        shareButton.backgroundColor = UIColor(cgColor: CGColor(gray: 0, alpha: 0.2))
        //favouriteButton.layer.cornerRadius = favouriteButton.frame.height/3
        shareButton.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        shareButton.layer.masksToBounds = false
        shareButton.layer.shadowRadius = 5
        shareButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        shareButton.layer.shadowOpacity = 1
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
        //pieChart.centerText = "Democratic score:..."
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
    
    func retrieveResultFromCoreData() -> Favorite?
    {
        //remove from favourites
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
}
