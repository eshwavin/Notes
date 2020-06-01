//
//  Note.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 01/06/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

final class Note: NSManagedObject {
    @NSManaged fileprivate(set) var content: String
    @NSManaged fileprivate(set) var dateModified: Date
    @NSManaged fileprivate(set) var title: String
    
    static func insert(into context: NSManagedObjectContext) -> Note {
        let note: Note = context.insertObject()
        note.title = ""
        note.dateModified = Date()
        note.content = ""
        return note
    }
    
}

extension Note: Managed {
    static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(dateModified), ascending: false)]
    }
}
