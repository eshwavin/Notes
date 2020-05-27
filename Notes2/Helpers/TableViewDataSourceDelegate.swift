//
//  TableViewDataSourceDelegate.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 27/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

protocol TableViewDataSourceDelegate: class {
//    associatedtype Object: NSFetchRequestResult
    associatedtype Cell: UITableViewCell
//    func configure(_ cell: Cell, for object: Object)
    func configure(_ cell: Cell, for note: (title: String, contents: String))
}
