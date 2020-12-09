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
    
    enum Filters:String
    {
        case date = "date"
        case area = "area"
    }
    
    static var currentFilter:Filters = Filters.date
    
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
    class func resultsMatching(key: String, filter:Filters, from data: [ElectionResponse]) -> [ElectionResponse]
    {
        var results:[ElectionResponse] = []
        
        switch(filter)
        {
        case .date:
            for item in data
            {
                if(item.date == key)
                {
                    results.append(item)
                }
            }
        case .area:
            for item in data
            {
                if(item.area == key)
                {
                    results.append(item)
                }
            }
        }
        
        return results
    }
    
    //MARK: SET MAKING f(x)s
    //extract all unique attributes from given data
    class func filterUniqueAttributes(attribute:Filters, data: [ElectionResponse]) -> [String]
    {
        var results:[String] = []
        
        switch(attribute)
        {
        case .date:
            for item in data
            {
                if results.firstIndex(of: item.date) == nil
                {
                    results.append(item.date)
                }
            }
        case .area:
            for item in data
            {
                if(results.firstIndex(of: item.area) == nil)
                {
                    results.append(item.area)
                }
            }
        }
        
        return results
    }
}
