//
//  DataModelConverter.swift
//  Weather
//
//  Created by Jacky Tjoa on 27/9/24.
//

import Foundation

class DataModelConverter {
    
    static func convertDataModelToViewModel(data: ResultItem,
                                            dateViewed: Date?) -> SearchCellModel {
        let displayText = "\(data.areaName.first?.value ?? ""), \(data.country.first?.value ?? "")"
        var noteText = ""
        if let dateViewed = dateViewed {
            let dateString = Util.formatDate(date: dateViewed)
            noteText = "Last viewed: \(dateString)"
        }
        let viewModel = SearchCellModel(displayText: displayText,
                                        noteText: noteText,
                                        noteTextColor: .gray)
        return viewModel
    }
    
    static func convertDataModelToStorageModel(data: ResultItem, dateViewed: Date) -> ViewedItem {
        //key is the combination of latitude and longitude to uniquely identify item
        let key = "\(data.latitude), \(data.longitude)"
        let viewedItem = ViewedItem(key: key,
                                    data: data,
                                    dateViewed: dateViewed)
        return viewedItem
    }
}
