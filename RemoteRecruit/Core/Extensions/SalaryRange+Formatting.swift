//
//  SalaryRange+Formatting.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

extension SalaryRange {
    
    /// "$165k – $200k" for annual salaries, or "$55 – $75/hr"
    var formatted: String {
        let symbol = currencySymbol
        if period == .year {
            return "\(symbol)\(thousands(min)) – \(symbol)\(thousands(max))"
        }
        return "\(symbol)\(min) – \(symbol)\(max)/\(period.shortName)"
    }
    
    var currencySymbol: String {
        switch currency.uppercased() {
            case "USD": return "$"
            case "EUR": return "€"
            case "GBP": return "£"
            case "CAD": return "C$"
            default: return "\(currency) "
        }
    }
    
    private func thousands(_ value: Int) -> String {
        "\(Int((Double(value) / 1000).rounded()))k"
    }
}
