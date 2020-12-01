//
//  ElectionResponse.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-11-30.
//

import Foundation

struct ElectionResponse : Codable
{
    let date: String
    let type: String
    let area: String
    let candidate: String
    let position: String
    let votes: String
    let won: String
        
    enum CodingKeys: String, CodingKey
    {
        case date
        case type
        case area
        case candidate
        case position
        case votes
        case won
    }
}
