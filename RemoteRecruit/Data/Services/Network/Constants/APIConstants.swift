//
//  APIConstants.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

typealias APIConstants = AppConstants.API

nonisolated enum AppConstants {
    
    enum API {
        /// Base URL, injected from the active xcconfig via Info.plist.
        static var baseURL: URL {
            guard
                let urlString = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String,
                let url = URL(string: urlString)
            else {
                fatalError("API_URL missing or invalid in Info.plist — check the xcconfig")
            }
            return url
        }
    }
}
