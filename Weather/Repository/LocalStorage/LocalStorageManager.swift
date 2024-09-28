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
    private let kStorageKey = "viewedItems"
    let localSource: LocalSourceDelegate? = UserDefaultsManager()
    
    func retrieveViewedItems(limit: Int, ordering: ItemOrdering) -> [ViewedItem] {
        guard let storedData = localSource?.read(key: kStorageKey) else {
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
        guard let storedData = localSource?.read(key: kStorageKey) else {
            do {
                let dataKey = DataModelConverter.constructDataKey(data: data)
                let lastViewed = DataModelConverter
                    .convertDataModelToStorageModel(
                        key: dataKey,
                        data: data,
                        dateViewed: Date())
                let encodedData = try JSONEncoder().encode([lastViewed])
                localSource?.write(value: encodedData, key: kStorageKey)
            } catch let error {
                print(error)
            }
            return
        }
        
        do {
            var storedLastViews = try JSONDecoder().decode([ViewedItem].self, from: storedData)
            let dataKey = DataModelConverter.constructDataKey(data: data)
            let lastViewed = DataModelConverter
                .convertDataModelToStorageModel(
                    key: dataKey,
                    data: data,
                    dateViewed: Date())
            storedLastViews.append(lastViewed)
            let encodedData = try JSONEncoder().encode(storedLastViews)
            localSource?.write(value: encodedData, key: kStorageKey)
            //TODO: cleanup storage
            //TODO: remove duplicate item
        } catch let error {
            print(error)
        }
    }
}
