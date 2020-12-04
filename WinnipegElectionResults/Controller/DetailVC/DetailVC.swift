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
        
        //set up title label
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = chartTitle
        
        var constraints = [NSLayoutConstraint]()
        
        //Add
        //constraints.append(title.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor))
        //constraints.append(title.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor))
        //constraints.append(title.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor))
        //constraints.append(title.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor))

        //Activate
        //NSLayoutConstraint.activate(constraints)
        
        //title.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        //title.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        
        pieChart.addSubview(title)
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
