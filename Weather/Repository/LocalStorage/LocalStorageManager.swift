//
//  LocalStorageManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalStorageManagerDelegate {
    func retrieveViewedCities(limit: Int) -> [ViewedItem]
    func saveViewedCity(data: ResultItem)
}

class LocalStorageManager: LocalStorageManagerDelegate {
    private let key = "viewedItems"
    let localSource: LocalSourceDelegate? = UserDefaultsManager()
    
    func retrieveViewedCities(limit: Int) -> [ViewedItem] {
        guard let storedData = localSource?.read(key: key) else {
            return []
        }
        do {
            let storedLastViews = try JSONDecoder().decode([ViewedItem].self, from: storedData)
            let sortedViews = storedLastViews.sorted(by: { $0.dateViewed > $1.dateViewed })
            let limitSortedViews = Array(sortedViews.prefix(limit))
            return limitSortedViews
        } catch let error {
            print(error)
        }
        return []
    }
    
    func saveViewedCity(data: ResultItem) {
        guard let storedData = localSource?.read(key: key) else {
            do {
                let lastViewed = convertDataModelToStorageModel(data: data)
                let encodedData = try JSONEncoder().encode([lastViewed])
                localSource?.write(value: encodedData, key: key)
            } catch let error {
                print(error)
            }
            return
        }
        
        do {
            var storedLastViews = try JSONDecoder().decode([ViewedItem].self, from: storedData)
            let lastViewed = convertDataModelToStorageModel(data: data)
            storedLastViews.append(lastViewed)
            let encodedData = try JSONEncoder().encode(storedLastViews)
            localSource?.write(value: encodedData, key: key)
            //TODO: cleanup storage
        } catch let error {
            print(error)
        }
    }
    
    private func convertDataModelToStorageModel(data: ResultItem) -> ViewedItem {
        //key is the combination of latitude and longitude to uniquely identify item
        let key = "\(data.latitude), \(data.longitude)"
        let lastViewedCity = ViewedItem(key: key,
                                        data: data,
                                        dateViewed: Date())
        return lastViewedCity
    }
}
