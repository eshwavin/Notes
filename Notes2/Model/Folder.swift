//
//  Folder.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 30/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

final class Folder: NSManagedObject {
    @NSManaged fileprivate(set) var dateModified: Date
    @NSManaged fileprivate(set) var name: String
    
    static func insert(into context: NSManagedObjectContext, for folderName: String) -> Folder {
        let folder: Folder = context.insertObject()
        folder.name = folderName
        folder.dateModified = Date()
        return folder
    }
}

extension Folder: Managed {
    static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(dateModified), ascending: false)]
    }
}
