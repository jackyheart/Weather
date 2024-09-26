//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalStorageProtocol {
    func retriveVisitedCities(limit: Int) -> [[String: Any]]?
    func persistVisitedCity(value: String)
}

class UserDefaultsManager: LocalStorageProtocol {
    let userDefaults = UserDefaults.standard
    let key = "visitedCities"
    
    func retriveVisitedCities(limit: Int) -> [[String: Any]]? {
        let storedData = userDefaults.array(forKey: key) as? [[String: Any]]
        return storedData
    }
    
    func persistVisitedCity(value: String) {
        let currentDate = Date()
        var storedData = userDefaults.array(forKey: key) as? [[String: Any]]
        storedData?.append(["city": value, "date": currentDate])
        userDefaults.set(storedData, forKey: key)
    }
}
