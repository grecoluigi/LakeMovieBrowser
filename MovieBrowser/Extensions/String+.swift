//
//  String+.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var yearFromDate : String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "yyyy"
        guard let date = dateFormatterGet.date(from:self) else { return nil }
        return dateFormatterSet.string(from: date)
    }
    
    func addParams(dict: [String: String]?) -> String {
        var string = self
        guard let dict = dict else {
            return self
        }
        for param in dict {
            string = string.replacingOccurrences(of: "{\(param.key)}", with: param.value)
        }
        return string
    }
}
