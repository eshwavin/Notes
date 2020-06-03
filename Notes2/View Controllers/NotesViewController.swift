//
//  DetailViewController.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 25/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var notesSource: NotesSource! {
        didSet {
            guard let folder = notesSource.managedObject else { return }
            observer = ManagedObjectObserver(object: folder, changeHandler: { [unowned self] (type) in
                guard type == .delete else { return }
                let _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    private var observer: ManagedObjectObserver?
    
    private var dataSource: TableViewDataSource<NotesViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        let request = Note.sortedFetchRequest(with: notesSource.predicate)
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: CellIdentifiers.notesCell.rawValue, fetchedResultsController: fetchedResultsController, delegate: self)
        
    }
}

extension NotesViewController: TableViewDataSourceDelegate {
    
    func configure(_ cell: NotesTableViewCell, for object: Note) {
        cell.configure(for: object)
    }
    
    
}
