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
    private let kStorageLimit = 10
    var localSource: LocalSourceDelegate? = UserDefaultsManager()
    
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
            let storedLastViews = try JSONDecoder().decode([ViewedItem].self, from: storedData)
            
            //only maintain n recently viewed items (descending order)
            let sortedViews = storedLastViews.sorted { $0.dateViewed > $1.dateViewed }
            var filteredSortedViews = Array(sortedViews.prefix(kStorageLimit))
            
            //remove duplicate
            let dataKey = DataModelConverter.constructDataKey(data: data)
            if let index = filteredSortedViews.firstIndex(where: { $0.key == dataKey }) {
                filteredSortedViews.remove(at: index)
            }
            
            //add newly viewed item
            let lastViewed = DataModelConverter
                .convertDataModelToStorageModel(
                    key: dataKey,
                    data: data,
                    dateViewed: Date())
            
            //if storage limit exceeded, remove last item (least recently visited item)
            if filteredSortedViews.count + 1 > kStorageLimit {
                filteredSortedViews.removeLast()
            }
            filteredSortedViews.append(lastViewed)
            
            //write to storage
            let encodedData = try JSONEncoder().encode(filteredSortedViews)
            localSource?.write(value: encodedData, key: kStorageKey)
        } catch let error {
            print(error)
        }
    }
}
