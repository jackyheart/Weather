//
//  LocalStorageManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalStorageDelegate {
    func retrieveViewedCities(limit: Int) -> [LastViewedCity]
    func saveViewedCity(data: SearchCellModel)
}

class LocalStorageManager: LocalStorageDelegate {
    private let key = "viewedCities"
    let localSource: LocalSourceDelegate = UserDefaultsManager()
    
    func retrieveViewedCities(limit: Int) -> [LastViewedCity] {
        guard let storedData = localSource.read(key: key) else {
            return []
        }
        do {
            let storedLastViews = try JSONDecoder().decode([LastViewedCity].self, from: storedData)
            let sortedViews = storedLastViews.sorted(by: { $0.dateViewed > $1.dateViewed })
            let limitSortedViews = Array(sortedViews.prefix(limit))
            return limitSortedViews
        } catch let error {
            print(error)
        }
        return []
    }
    
    func saveViewedCity(data: SearchCellModel) {
        guard let storedData = localSource.read(key: key) else {
            do {
                let lastViewed = LastViewedCity(data: data, dateViewed: Date())
                let encodedData = try JSONEncoder().encode([lastViewed])
                localSource.write(value: encodedData, key: key)
            } catch let error {
                print(error)
            }
            return
        }
        
        do {
            var storedLastViews = try JSONDecoder().decode([LastViewedCity].self, from: storedData)
            let lastViewed = LastViewedCity(data: data, dateViewed: Date())
            storedLastViews.append(lastViewed)
            let encodedData = try JSONEncoder().encode(storedLastViews)
            localSource.write(value: encodedData, key: key)
            //TODO: cleanup storage
        } catch let error {
            print(error)
        }
    }
}
