//
//  NSManagedObjectContext+Observers.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 01/06/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import Foundation
import CoreData

struct ObjectsDidChangeNotification {
    
    fileprivate let notification: Notification
    
    init(notification: Notification) {
        assert(notification.name == Notification.Name.NSManagedObjectContextObjectsDidChange)
        self.notification = notification
    }
    
    // MARK: Object types
    
    var insertedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInsertedObjectsKey)
    }
    
    var updatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSUpdatedObjectsKey)
    }
    
    var deletedObjects: Set<NSManagedObject> {
        return objects(forKey: NSDeletedObjectsKey)
    }
    
    var refreshedObjects: Set<NSManagedObject> {
        return objects(forKey: NSRefreshedObjectsKey)
    }
    
    var invalidatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInvalidatedObjectsKey)
    }
    
    var invalidatedAllObjects: Bool {
        return (notification as NSNotification).userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
    
    fileprivate func objects(forKey key: String) -> Set<NSManagedObject> {
        return ((notification as NSNotification).userInfo?[key] as? Set<NSManagedObject>) ?? Set()
    }
    
}

extension NSManagedObjectContext {
    
    func addObjectsDidChangeNotificationObserver(_ handler: @escaping (ObjectsDidChangeNotification) -> ()) -> NSObjectProtocol {
        
        let notificationCenter = NotificationCenter.default
        
        return notificationCenter.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: self, queue: nil) { (notification) in
            let wrappedNote = ObjectsDidChangeNotification(notification: notification)
            handler(wrappedNote)
        }
        
    }
    
}
