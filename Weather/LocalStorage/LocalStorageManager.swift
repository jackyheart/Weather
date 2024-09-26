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
    let latitude: String
    let longitude: String
    let dateViewed: Date
}

class LocalStorageManager: LocalStorageDelegate {
    let userDefaults = UserDefaults.standard
    let key = "viewedCities"
    
    func retrieveViewedCities(limit: Int) -> [LastViewed] {
        guard var storedData = userDefaults.object(forKey: key) as? Data else {
            return []
        }
        do {
            let storedLastViews = try JSONDecoder().decode([LastViewed].self, from: storedData)
            //TODO: sort and limit
            return storedLastViews
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
            var storedLastViews = try JSONDecoder().decode([LastViewed].self, from: storedData)
            //TODO: retrieve lat, long from data model
            let lastViewed = LastViewed(displayText: value, latitude: "", longitude: "", dateViewed: Date())
            storedLastViews.append(lastViewed)
            let encodedData = try JSONEncoder().encode(storedLastViews)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            //error handling
        }
    }
}
