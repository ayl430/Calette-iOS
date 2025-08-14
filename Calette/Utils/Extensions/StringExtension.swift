//
//  StringExtension.swift
//  Calette
//
//  Created by yeri on 2/2/25.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func hyphenToDot() -> String {
        return self.replacingOccurrences(of: "-", with: ".")
    }    
    
    var byCharWrapping: Self {
        self.split(separator: "").joined(separator: "\u{200B}")
    }
}
