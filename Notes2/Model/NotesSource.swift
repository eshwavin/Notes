//
//  NoteSource.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 03/06/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import Foundation
import CoreData

enum NotesSource {
    case all
    case folder(Folder)
}

extension NotesSource {
    
    var predicate: NSPredicate {
        switch self {
        case .all:
            return NSPredicate(value: true)
        case .folder(let folder):
            return NSPredicate(format: "folder = %@", argumentArray: [folder])
        }
    }
    
    var managedObject: NSManagedObject? {
        switch self {
        case .all:
            return nil
        case .folder(let folder):
            return folder
        }
    }
    
}
