//
//  LocalStorageManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalStorageDelegate {
    func retrieveViewedCities(limit: Int) -> [LastViewedCity]
    func saveViewedCity(value: String)
}

struct LastViewedCity: Codable {
    let displayText: String
    let latitude: String
    let longitude: String
    let dateViewed: Date
}

class LocalStorageManager: LocalStorageDelegate {
    private let key = "viewedCities"
    let localSource: LocalSourceDelegate = UserDefaultsManager()
    
    func retrieveViewedCities(limit: Int) -> [LastViewedCity] {
        guard var storedData = localSource.read(key: key) else {
            return []
        }
        do {
            let storedLastViews = try JSONDecoder().decode([LastViewedCity].self, from: storedData)
            //TODO: sort and limit
            return storedLastViews
        } catch {
            //Logging
            print("read error from local storage")
        }
        return []
    }
    
    func saveViewedCity(value: String) {
        guard var storedData = localSource.read(key: key) else {
            return
        }
        do {
            var storedLastViews = try JSONDecoder().decode([LastViewedCity].self, from: storedData)
            //TODO: retrieve lat, long from data model
            let lastViewed = LastViewedCity(displayText: value, latitude: "", longitude: "", dateViewed: Date())
            storedLastViews.append(lastViewed)
            let encodedData = try JSONEncoder().encode(storedLastViews)
            localSource.write(value: encodedData, key: key)
        } catch {
            //Logging
            print("write error to local storage")
        }
    }
}
