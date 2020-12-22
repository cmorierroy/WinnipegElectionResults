//
//  WODClient.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-11-30.
//

import Foundation
import Alamofire

class WODClient
{
    //MARK: Endpoints
    //let appToken = "3pTTDKHHo0gRaMHo5jeM5311E"

    enum Endpoints
    {
        static let base = "https://data.winnipeg.ca/resource"
        static let electionDataset = "/7753-3fjc.json"
        
        case getElections(String)
        
        var stringValue: String
        {
            switch self
            {
            case.getElections(let electionType):
                if(electionType == "ALL")
                {
                    return Endpoints.base + Endpoints.electionDataset + "?$limit=5000"
                }
                else
                {
                    return Endpoints.base + Endpoints.electionDataset + "?type=\(urlify(string:electionType))"
                }
            }
            
        }
        
        var url: URL
        {
            return URL(string: stringValue)!
        }
    }
    
    class func urlify(string: String) -> String
    {
        //substitute spaces with url-safe strings
        return string.replacingOccurrences(of: " ", with: "%20")
    }
    
    //MARK: GET Request GENERIC
    class func taskForGETRequest<ResponseType:Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask
    {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request)
        { data, response, error in
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    completion(nil, error)
                }
                return
            }
                        
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async
                {
                    completion(responseObject, nil)
                }
            }
            catch
            {
                DispatchQueue.main.async
                {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    //MARK: GET REQUESTS
    class func getElections(electionType: String, completion: @escaping ([ElectionResponse], Error?) -> Void )
    {
        _ = taskForGETRequest(url: Endpoints.getElections(electionType).url, response: [ElectionResponse].self)
        { (response, error) in
            if let response = response
            {
                completion(response, nil)
            }
            else
            {
                completion([], error)
            }
        }
    }
}
