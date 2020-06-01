//
//  NotesDataSource.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 27/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

protocol TableViewDataSourceDelegate: class {
    associatedtype Object: NSFetchRequestResult
    associatedtype Cell: UITableViewCell
    func configure(_ cell: Cell, for object: Object)
}

class TableViewDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: Init Properties
    
    private weak var tableView: UITableView?
    private weak var delegate: Delegate?
    private let cellIdentifier: String
    private let fetchedResultsController: NSFetchedResultsController<Object>
    
    // MARK: Protocol associated types
    
    typealias Cell = Delegate.Cell
    typealias Object = Delegate.Object
    
    // MARK: Objects
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    
    // MARK: Initialisation
    
    required init(tableView: UITableView, cellIdentifier: String, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        
        
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    // MARK: TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return section.numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError("Unexpected Cell Type at \(indexPath)")
        }
        
        let object = fetchedResultsController.object(at: indexPath)
        delegate?.configure(cell, for: object)
        
        return cell
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { fatalError("newIndexPath is nil") }
            tableView?.insertRows(at: [newIndexPath], with: .fade)
        
        case .update:
            guard let indexPath = indexPath else { fatalError("indexPath is nil ") }
            let object = objectAtIndexPath(indexPath)
            guard let cell = tableView?.cellForRow(at: indexPath) as? Cell else { break }
            delegate?.configure(cell, for: object)
            
        case .move:
            guard let indexPath = indexPath else { fatalError("indexPath is nil") }
            guard let newIndexPath = newIndexPath else { fatalError("newIndexPath is nil") }
            tableView?.deleteRows(at: [indexPath], with: .fade)
            tableView?.insertRows(at: [newIndexPath], with: .fade)
            
        case .delete:
            guard let indexPath = indexPath else { fatalError("indexPath is nil") }
            tableView?.deleteRows(at: [indexPath], with: .fade)
            
        @unknown default:
            fatalError("New case added")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
    
    // MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let object = objectAtIndexPath(indexPath) as? NSManagedObject else { return }
            
            object.managedObjectContext?.performChanges {
                object.managedObjectContext?.delete(object)
            }
        }
    }
    
}

