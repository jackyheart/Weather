//
//  LocalStorageManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalStorageManagerDelegate {
    func retrieveViewedItems(limit: Int) -> [ViewedItem]
    func saveViewedItem(data: ResultItem)
}

class LocalStorageManager: LocalStorageManagerDelegate {
    private let key = "viewedItems"
    let localSource: LocalSourceDelegate? = UserDefaultsManager()
    
    func retrieveViewedItems(limit: Int) -> [ViewedItem] {
        guard let storedData = localSource?.read(key: key) else {
            return []
        }
        do {
            let storedLastViews = try JSONDecoder().decode([ViewedItem].self, from: storedData)
            let limitSortedViews = Array(storedLastViews.prefix(limit))
            return limitSortedViews
        } catch let error {
            print(error)
        }
        return []
    }
    
    func saveViewedItem(data: ResultItem) {
        guard let storedData = localSource?.read(key: key) else {
            do {
                let lastViewed = DataModelConverter.convertDataModelToStorageModel(data: data)
                let encodedData = try JSONEncoder().encode([lastViewed])
                localSource?.write(value: encodedData, key: key)
            } catch let error {
                print(error)
            }
            return
        }
        
        do {
            var storedLastViews = try JSONDecoder().decode([ViewedItem].self, from: storedData)
            let lastViewed = DataModelConverter.convertDataModelToStorageModel(data: data)
            storedLastViews.append(lastViewed)
            let encodedData = try JSONEncoder().encode(storedLastViews)
            localSource?.write(value: encodedData, key: key)
            //TODO: cleanup storage
            //TODO: remove duplicate item
        } catch let error {
            print(error)
        }
    }
}
