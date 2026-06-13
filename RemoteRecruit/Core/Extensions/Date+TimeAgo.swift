//
//  Date+TimeAgo.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

extension Date {
    
    var timeAgo: String {
        let minutes = Int(Date().timeIntervalSince(self) / 60)
        if minutes < 60 {
            return minutes <= 1 ? "Just now" : "\(minutes)m ago"
        }
        let hours = minutes / 60
        if hours < 24 {
            return "\(hours)h ago"
        }
        let days = hours / 24
        if days < 7 {
            return "\(days)d ago"
        }
        return "\(days / 7)w ago"
    }
}
