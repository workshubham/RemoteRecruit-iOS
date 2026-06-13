//
//  JobNavigation.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI


enum JobDestination: Hashable {
    case detail(jobID: String)
}

extension View {
    
    func jobNavigationDestinations(in namespace: Namespace.ID) -> some View {
        modifier(JobNavigationDestinations(namespace: namespace))
    }
}

private struct JobNavigationDestinations: ViewModifier {
    let namespace: Namespace.ID
    
    func body(content: Content) -> some View {
        content.navigationDestination(for: JobDestination.self) { destination in
            switch destination {
                case .detail(let jobID):
                    JobDetailView(jobID: jobID)
                        .navigationTransition(.zoom(sourceID: jobID, in: namespace))
            }
        }
    }
}
