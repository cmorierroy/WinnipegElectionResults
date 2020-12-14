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
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var chartTitle:String = ""
    var results:[ElectionResponse] = []
    
    //MARK: LIFECYCLE f(x)s
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set up title label
        subTitle.text = chartTitle        
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
        let chartColors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
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
