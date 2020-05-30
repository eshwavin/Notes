//
//  ViewController.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 25/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class FoldersViewController: UITableViewController {

    private var dataSource: FoldersDataSourceDelegate<FoldersViewController>?
    
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: Alert
    
    var createNewFolderAlert: UIAlertController {
        let alert = UIAlertController(title: "New Folder", message: "Enter a name for the new folder", preferredStyle: .alert)
        alert.addTextField {
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
    }
    
    var errorAlert: UIAlertController {
        let alert = UIAlertController(title: "Name Taken", message: "Please choose a different name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        dataSource = FoldersDataSourceDelegate(tableView: tableView, cellIdentifier: CellIdentifiers.notesMasterCell.rawValue, delegate: self)
        
    }
    
    // MARK: Add Folder
    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
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
        return true
    }
    
    
    
}

extension FoldersViewController: TableViewDataSourceDelegate {
    func configure(_ cell: NotesTableViewCell, for folder: String) {
        cell.configure(for: folder)
    }
}

