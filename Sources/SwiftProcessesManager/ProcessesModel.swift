//
//  ProcessesModel.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation
import CommunicationProtocolSDK

class ProcessesModel {
    private(set) var items: [Process]
    required init(_ items: [Process]) {
        self.items = items
    }
    convenience init() {
        self.init([])
    }
}

extension ProcessesModel {
    struct Process {
        let id: Int
        let name: String
        let owner: String
    }
}

extension ProcessesModel {
    static func mock() -> Self {
        .init([
            .init(id: 0, name: "1", owner: "2"),
            .init(id: 3, name: "4", owner: "5"),
            .init(id: 6, name: "7", owner: "8")
        ])
    }
}

// MARK: Process Converter
extension ProcessesModel {
    enum ProcessesConverter {
        private static func asOurProcess(_ model: CommunicationProtocolSDK.Process) -> ProcessesModel.Process {
            .init(id: model.id, name: model.name, owner: model.owner)
        }
        static func asProcessesModel(_ model: ProcessList) -> ProcessesModel {
            .init(model.list.map(asOurProcess))
        }
    }
}
