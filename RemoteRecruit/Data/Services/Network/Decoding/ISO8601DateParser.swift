//
//  ISO8601DateParser.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

/// The backend sends timestamps with fractional seconds (e.g.
/// "2026-06-13T06:00:00.000Z"), which the default ISO8601 strategy rejects.
/// This tries the fractional format first, then plain ISO8601.
enum ISO8601DateParser {

    private static let withFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let plain: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    static func date(from string: String) -> Date? {
        withFractional.date(from: string) ?? plain.date(from: string)
    }
}
