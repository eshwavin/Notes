//
//  NSManagedObjectContext+Extensions.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 30/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    
    // TODO: Check for cleaner code
    func insertUniqueObject<A: NSManagedObject>(with predicate: NSPredicate) -> A? where A: Managed {
        
        let fetchRequest = NSFetchRequest<A>(entityName: A.entityName)
        fetchRequest.predicate = predicate
        
        if (try! self.fetch(fetchRequest)).count > 0 {
            return insertObject()
        }
        else {
            return nil
        }
        
    }
    
    // MARK: Insertion
    
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return object
    }
    
    func saveOrRollBack() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    func performChanges(block: @escaping () -> ()) {
        perform { [unowned self] in
            block()
            _ = self.saveOrRollBack()
        }
    }
    
    func performChangesAndWait(block: @escaping () -> ()) -> Bool {
        var isSuccess = false
        
        performAndWait { [unowned self] in
            block()
            isSuccess = self.saveOrRollBack()
        }
        
        return isSuccess
    }
    
    
    
}
