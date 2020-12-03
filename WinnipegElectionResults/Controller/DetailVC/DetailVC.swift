//
//  DetailVC.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-03.
//

import UIKit
import Charts

class DetailVC: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!
    
    var chartTitle:String = ""
    var results:[ElectionResponse] = []
    
    //MARK: LIFECYCLE f(x)s
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadPieChart()
        pieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
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
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        //Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        //Assign it to the chart’s data
        
        //CUSTOMIZATION OF PIE CHART
        pieChart.largeContentTitle = chartTitle
        pieChart.holeColor = .black
        pieChart.data = pieChartData
        pieChart.backgroundColor = .black
        
        //customize legend
        pieChart.legend.textColor = .white
        
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
