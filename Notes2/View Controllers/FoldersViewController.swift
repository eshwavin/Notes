//
//  ViewController.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 25/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class FoldersViewController: UITableViewController, SegueHandler {

    private var dataSource: TableViewDataSource<FoldersViewController>?
    
    var managedObjectContext: NSManagedObjectContext!
    
    enum SegueIdentifier: String {
        case showNotes = "showNotes"
    }
    
    // MARK: Alerts
    
    lazy var createNewFolderAlert: UIAlertController = {
        let alert = UIAlertController(title: "New Folder", message: "Enter a name for the new folder", preferredStyle: .alert)
        
        alert.addTextField { [unowned self] in
            $0.placeholder = "Name"
            $0.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] (_) in
            
            guard let text = alert.textFields?.first?.text else { return }
            
            let isSuccess = self.createNewFolder(text)
            
            if !isSuccess {
                self.present(self.errorAlert, animated: true, completion: nil)
            }
        }
        
        saveAction.isEnabled = false
        alert.addAction(saveAction)
        
        return alert
    }()
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "Name Taken", message: "Please choose a different name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }()
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        let request = Folder.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        
        let fetchedRequestController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: CellIdentifiers.folderCell.rawValue, fetchedResultsController: fetchedRequestController, delegate: self)
        
    }
    
    // MARK: Add Folder
    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
        
        createNewFolderAlert.textFields?.first?.text = ""
        createNewFolderAlert.actions.last?.isEnabled = false
        
        self.present(createNewFolderAlert, animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let alert = presentedViewController as? UIAlertController,
            let saveAction = alert.actions.last,
            let text = textField.text {
            saveAction.isEnabled = text.count > 0
        }
    }
    
    private func createNewFolder(_ name: String) -> Bool {
        var isSuccess = false
        
        isSuccess = managedObjectContext.performChangesAndWait { [unowned self] in
            _ = Folder.insert(into: self.managedObjectContext, for: name)
        }
        
        return isSuccess
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue){
        case .showNotes:
//            guard let viewController = segue.destination as? NotesViewController else {
//                    fatalError("Wrong view controller")
//            }
            
            guard let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? NotesViewController else {
                    fatalError("Wrong view controller")
            }
            
            guard let folder = dataSource?.selectedObject else {
                fatalError("Wrong object type")
            }
            viewController.managedObjectContext = managedObjectContext
            viewController.notesSource = .folder(folder)
        }
        
        // deselecting rows before segue
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
}

// MARK: TableViewDataSourceDelegate

extension FoldersViewController: TableViewDataSourceDelegate {
    func configure(_ cell: FolderTableViewCell, for object: Folder) {
        cell.configure(for: object)
    }
}

