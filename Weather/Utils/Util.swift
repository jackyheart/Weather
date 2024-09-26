//
//  Util.swift
//  Weather
//
//  Created by Jacky Tjoa on 27/9/24.
//

import Foundation

class Util {
    
    static func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY hh:mm:ss a"
        return dateFormatter.string(from: date)
    }
}
