//
//  CoreDataStack.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 27/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import CoreData

func createMoodyContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    let container = NSPersistentContainer(name: "Notes")
    container.loadPersistentStores { (_, error) in
        guard error == nil else {
            fatalError("Failed to load persistent store: \(error!.localizedDescription)")
        }
        DispatchQueue.main.async {
            completion(container)
        }
    }
}
