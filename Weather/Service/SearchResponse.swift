//
//  SearchData.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

struct SearchResponse: Codable {
    let searchApi: String
    let result: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case searchApi = "search_api"
        case result
    }
}

struct SearchResult: Codable {
    let areaName: [ValueList]
    let country: [ValueList]
    let region: [ValueList]
    let latitude: String
    let longitude: String
    let weatherUrl: [ValueList]
}

struct ValueList: Codable {
    let value: String
}
