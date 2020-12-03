//
//  ElectionData.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-01.
//

import Foundation

class ElectionData
{
    static var all:[ElectionResponse] = []
    static var types:[String] = []
    static var dates:[String] = []
    static var wards:[String] = []
    
    //MARK: FILTERING f(x)s
    //return all results with given type (General Election or By-Election, so far.)
    class func resultsMatching(type: String) -> [ElectionResponse]
    {
        var results:[ElectionResponse] = []
        
        for item in all
        {
            if(item.type == type)
            {
                results.append(item)
            }
        }
        
        return results
    }
    
    //return all results from passed data whose date attribute matches the date parameter
    class func resultsMatching(date: String, from data: [ElectionResponse]) -> [ElectionResponse]
    {
        var results:[ElectionResponse] = []
        
        for item in data
        {
            if(item.date == date)
            {
                results.append(item)
            }
        }
        
        return results
    }
    
    //return all results from passed data whose area attribute matches the ward parameter
    class func resultsMatching(ward: String, from data: [ElectionResponse]) -> [ElectionResponse]
    {
        var results:[ElectionResponse] = []
        
        for item in data
        {
            if(item.area == ward)
            {
                results.append(item)
            }
        }
        
        return results
    }
    
    //MARK: SET MAKING f(x)s
    //extract all unique dates from given data
    class func uniqueDates(data:[ElectionResponse])
    {
        ElectionData.dates = []
        
        for item in data
        {
            if(ElectionData.dates.firstIndex(of: item.date) == nil)
            {
                ElectionData.dates.append(item.date)
            }
        }
    }
    
    //extract all unique wards/areas from given data
    class func uniqueWards(data: [ElectionResponse])
    {
        ElectionData.wards = []
        
        for item in data
        {
            if(ElectionData.wards.firstIndex(of: item.area) == nil)
            {
                ElectionData.wards.append(item.area)
            }
        }
        
    }
}
