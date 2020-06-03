//
//  ManagedObjectObserver.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 01/06/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import Foundation
import CoreData

final class ManagedObjectObserver {
    
    enum ChangeType {
        case delete
        case update
    }
    
    fileprivate var token: NSObjectProtocol!
    
    init?(object: NSManagedObject, changeHandler: @escaping (ChangeType) -> ()) {
        guard let context = object.managedObjectContext else { return nil }
        
        token = context.addObjectsDidChangeNotificationObserver { [weak self] notification in
            guard let changeType = self?.changeType(of: object, in: notification) else { return }
            changeHandler(changeType)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(token as Any)
    }
    
    fileprivate func changeType(of object: NSManagedObject, in note: ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        if note.invalidatedAllObjects || deleted.containsObjectIdentical(to: object) {
            return .delete
        }
        let updated = note.updatedObjects.union(note.invalidatedObjects)
        if updated.containsObjectIdentical(to: object) {
            return .update
        }
        return nil
    }
}
