//
//  DetailViewController.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 25/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, SegueHandler {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNewNoteButton: UIBarButtonItem!
    
    // MARK: SegueHandler/Nav
    
    enum SegueIdentifier: String {
        case showNote = "showNote"
    }
    
    
    // MARK: Core Data
    
    var managedObjectContext: NSManagedObjectContext!
    var notesSource: NotesSource! {
        didSet {
            guard let folder = notesSource.managedObject else { return }
            observer = ManagedObjectObserver(object: folder, changeHandler: { [unowned self] (type) in
                guard type == .delete else { return }
                self.invalidateView()
                let _ = self.navigationController?.popViewController(animated: true)
            })
            setupView()
        }
    }
    var selectedNote: Note?
    
    private var observer: ManagedObjectObserver?
    private var dataSource: TableViewDataSource<NotesViewController>!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Setup
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        setupFetchedRequestController()
    }
    
    private func setupFetchedRequestController() {
        
        if notesSource == nil {
            self.createNewNoteButton.isEnabled = false
            return
        }
        
        self.createNewNoteButton.isEnabled = true
        
        let request = Note.sortedFetchRequest(with: notesSource.predicate)
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: CellIdentifiers.notesCell.rawValue, fetchedResultsController: fetchedResultsController, delegate: self)

    }
    
    private func setupView() {
        if let name = (notesSource?.managedObject as? Folder)?.name {
            title = name
        }
    }
    
    private func invalidateView() {
        title = ""
        createNewNoteButton.isEnabled = false
    }
    
    // MARK: Note Creation
    
    @IBAction func createNewNote(_ sender: UIBarButtonItem) {
        
        managedObjectContext.performChanges { [unowned self] in
            guard let folder = self.notesSource.managedObject as? Folder else { return }
            self.selectedNote = Note.insert(into: self.managedObjectContext, in: folder)
            self.performSegue(withIdentifier: .showNote)
        }
        
        
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showNote:

            guard let viewController = segue.destination as? NoteViewController else {
                fatalError("Wrong view controller type")
            }
            if let note = dataSource.selectedObject {
                viewController.note = note
            }
            else if let note = selectedNote {
                viewController.note = note
            }
            else {
                fatalError("No selected note")
            }
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        
    }
}

// MARK: TableViewDataSourceDelegate

extension NotesViewController: TableViewDataSourceDelegate {
    
    func configure(_ cell: NotesTableViewCell, for object: Note) {
        cell.configure(for: object)
    }
    
}
