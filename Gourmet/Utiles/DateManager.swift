//
//  DateManager.swift
//  Gourmet
//
//  Created by 최승범 on 8/19/24.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    private let dateFormatter = DateFormatter()
    
    private init() {}
    
    func stringToDate(value: String) -> Date? {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: value)
    }
    
    func dateToString(date: Date) -> String {
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"

        return dateFormatter.string(from: date)
    }
    
    
    
    
}
