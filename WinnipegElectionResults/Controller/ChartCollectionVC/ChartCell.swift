//
//  ChartCell.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-21.
//

import Foundation
import UIKit
import Charts

class ChartCell : UICollectionViewCell
{
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
        pieChartDataSet.colors = UIColor.generateRandomColors(numbersOfColor: dataPoints.count)
        
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
        //pieChart.centerText = "Democratic score:..."
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
        let chartColors = UIColor.generateRandomColors(numbersOfColor: dataPoints.count)
        
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
}
