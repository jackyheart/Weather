//
//  LocalStorageManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalStorageDelegate {
    func retrieveViewedCities(limit: Int) -> [LastViewed]
    func saveViewedCity(value: String)
}

struct LastViewed: Codable {
    let displayText: String
    let viewedDate: Date
}

class LocalStorageManager: LocalStorageDelegate {
    let userDefaults = UserDefaults.standard
    let key = "visitedCities"
    
    func retrieveViewedCities(limit: Int) -> [LastViewed] {
        guard var storedData = userDefaults.object(forKey: key) as? Data else {
            return []
        }
        do {
            let storedLastVisited = try JSONDecoder().decode([LastViewed].self, from: storedData)
            //TODO: sort and limit
            return storedLastVisited
        } catch {
            //error handling
        }
        return []
    }
    
    func saveViewedCity(value: String) {
        guard var storedData = userDefaults.object(forKey: key) as? Data else {
            return
        }

        do {
            let storedLastVisited = try JSONDecoder().decode([LastViewed].self, from: storedData)
            let lastViewed = LastViewed(displayText: value, viewedDate: Date())
            let encodedData = try JSONEncoder().encode(lastViewed)
            storedData.append(encodedData)
            userDefaults.set(storedData, forKey: key)
        } catch {
            //error handling
        }
    }
}
