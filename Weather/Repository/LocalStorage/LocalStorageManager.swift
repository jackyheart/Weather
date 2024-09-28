//
//  LocalStorageManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalStorageManagerDelegate {
    func retrieveViewedItems(limit: Int, ordering: ItemOrdering) -> [ViewedItem]
    func saveViewedItem(data: ResultItem)
}

class LocalStorageManager: LocalStorageManagerDelegate {
    private let key = "viewedItems"
    let localSource: LocalSourceDelegate? = UserDefaultsManager()
    
    func retrieveViewedItems(limit: Int, ordering: ItemOrdering) -> [ViewedItem] {
        guard let storedData = localSource?.read(key: key) else {
            return []
        }
        do {
            let storedLastViews = try JSONDecoder().decode([ViewedItem].self, from: storedData)
            let sortedViews = storedLastViews.sorted(by: {
                switch ordering {
                case .descending:
                    $0.dateViewed > $1.dateViewed
                case .ascending:
                    $0.dateViewed < $1.dateViewed
                }
            })
            let limitSortedViews = Array(sortedViews.prefix(limit))
            return limitSortedViews
        } catch let error {
            print(error)
        }
        return []
    }
    
    func saveViewedItem(data: ResultItem) {
        guard let storedData = localSource?.read(key: key) else {
            do {
                let lastViewed = DataModelConverter
                    .convertDataModelToStorageModel(
                        data: data,
                        dateViewed: Date())
                let encodedData = try JSONEncoder().encode([lastViewed])
                localSource?.write(value: encodedData, key: key)
            } catch let error {
                print(error)
            }
            return
        }
        
        do {
            var storedLastViews = try JSONDecoder().decode([ViewedItem].self, from: storedData)
            let lastViewed = DataModelConverter
                .convertDataModelToStorageModel(
                    data: data,
                    dateViewed: Date())
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
