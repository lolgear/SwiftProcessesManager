//
//  ProcessGatherer.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation
import Darwin
import CommunicationProtocolUtilities

enum ProcessGatherer {
    struct Parameters {
        let onlyLoggedInUser: Bool
        static let all: Self = .init(onlyLoggedInUser: true)
    }
    
    static func gatherProcesses(_ parameters: Parameters = .all) -> ProcessList {
        guard let processes = ProcessGathererUtility.allProcesses else {
            return .init(list: [])
        }
        
        return .init(list: processes.map({ value in
            .init(id: value.pid.intValue, name: value.name, owner: value.owner)
        }))
    }
}

// MARK: - Filtering
private extension ProcessGatherer {
    struct Filtering {
//        static var currentUser: String {
//            getuid()
//        }
//        static func filter(list: ProcessList, _ parameters: Parameters) -> ProcessList {
//            .init(list: list.list.filter({
//
//            }))
//        }
    }
}
