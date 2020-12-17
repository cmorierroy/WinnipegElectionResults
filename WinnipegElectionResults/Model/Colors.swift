//
//  Colors.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-03.
//

import UIKit

extension UIColor
{
    struct AppTheme
    {
        static var paleYellow: UIColor  { return UIColor(red: 254.0/255, green: 244.0/255, blue: 157.0/255, alpha: 1) }
        static var gray: CGColor { return CGColor(gray: 0, alpha: 0.4) }
    }
    
    //randomizes colors for pie chart
    class func generateRandomColors(numbersOfColor: Int) -> [UIColor]
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
