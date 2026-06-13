//
//  SalaryFormattingTests.swift
//  RemoteRecruitTests
//
//  Created by Shubham Arora on 13/06/26.
//

import Testing
import Foundation
@testable import RemoteRecruit

struct SalaryFormattingTests {

    @Test func annualUSDUsesCompactThousands() {
        let salary = SalaryRange(min: 165_000, max: 200_000, currency: "USD", period: .year)
        #expect(salary.formatted == "$165k – $200k")
    }

    @Test func currencySymbolsMapCorrectly() {
        #expect(SalaryRange(min: 1, max: 2, currency: "EUR", period: .year).currencySymbol == "€")
        #expect(SalaryRange(min: 1, max: 2, currency: "GBP", period: .year).currencySymbol == "£")
        #expect(SalaryRange(min: 1, max: 2, currency: "CAD", period: .year).currencySymbol == "C$")
    }

    @Test func nonAnnualShowsPeriod() {
        let hourly = SalaryRange(min: 55, max: 75, currency: "USD", period: .hour)
        #expect(hourly.formatted == "$55 – $75/hr")
    }
}
