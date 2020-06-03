//
//  Folder.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 30/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class Folder: NSManagedObject {
    @NSManaged fileprivate(set) var dateCreated: Date
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var notes: Set<Note>
    
    @NSManaged fileprivate var primitiveDateCreated: Date
    
    static func insert(into context: NSManagedObjectContext, for folderName: String) -> Folder {
        let folder: Folder = context.insertObject()
        folder.name = folderName
        folder.dateCreated = Date()
        return folder
    }
    
//    override func awakeFromInsert() {
//        super.awakeFromInsert()
//        primitiveDateCreated = Date()
//    }
}

extension Folder: Managed {
    static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(dateCreated), ascending: true)]
    }
}
