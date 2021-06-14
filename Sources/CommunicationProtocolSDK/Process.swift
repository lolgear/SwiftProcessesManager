//
//  Process.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation
@objc(CommunicationProtocolProcessObject)
public class Process: NSObject, NSSecureCoding {
    private struct ObjcBridge {
        let value: Process
        var id: Int { self.value.id }
        var name: NSString { self.value.name as NSString }
        var owner: NSString { self.value.owner as NSString }
    }
    
    public static var supportsSecureCoding: Bool { true }
    
    public func encode(with coder: NSCoder) {
        let bridge: ObjcBridge = .init(value: self)
        coder.encode(bridge.id, forKey: "id")
        coder.encode(bridge.name, forKey: "name")
        coder.encode(bridge.owner, forKey: "owner")
    }
    
    public required init?(coder: NSCoder) {
        self.id = coder.decodeInteger(forKey: "id")
        self.name = coder.decodeObject(of: NSString.self, forKey: "name") as String? ?? ""
        self.owner = coder.decodeObject(of: NSString.self, forKey: "owner") as String? ?? ""
    }
    
    public let id: Int
    public let name: String
    public let owner: String
    internal init(id: Int, name: String, owner: String) {
        self.id = id
        self.name = name
        self.owner = owner
    }
}

@objc(CommunicationProtocolProcessListObject)
public class ProcessList: NSObject, NSSecureCoding {
    private struct ObjcBridge {
        let value: ProcessList
        var list: NSArray { self.value.list as NSArray }
    }
    
    public static var supportsSecureCoding: Bool { true }
    
    public func encode(with coder: NSCoder) {
        let bridge: ObjcBridge = .init(value: self)
        coder.encode(bridge.list, forKey: "list")
    }
    
    public required init?(coder: NSCoder) {
        self.list = coder.decodeObject(of: [NSArray.self, Process.self], forKey: "list").flatMap({ value in
            value as? [Process]
        }) ?? []
    }
    
    public var list: [Process]
    internal init(list: [Process]) {
        self.list = list
    }
}
