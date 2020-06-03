//
//  Note.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 01/06/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class Note: NSManagedObject {
    
    @NSManaged var content: String
    @NSManaged var dateModified: Date
    @NSManaged var title: String
    @NSManaged private(set) var folder: Folder
    
    static func insert(into context: NSManagedObjectContext, in folder: Folder) -> Note {
        let note: Note = context.insertObject()
        note.dateModified = Date()
        note.folder = folder
        return note
    }
    
}

extension Note: Managed {
    static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(dateModified), ascending: false)]
    }
}
