//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalStorageProtocol {
    func retriveVisitedCities(limit: Int) -> [LastViewed]
    func persistVisitedCity(value: String)
}

struct LastViewed: Codable {
    let displayText: String
    let viewedDate: Date
}

class UserDefaultsManager: LocalStorageProtocol {
    let userDefaults = UserDefaults.standard
    let key = "visitedCities"
    
    func retriveVisitedCities(limit: Int) -> [LastViewed] {
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
    
    func persistVisitedCity(value: String) {
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
