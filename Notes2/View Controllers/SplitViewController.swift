//
//  SplitViewController.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 27/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentsWithGesture = false
        preferredDisplayMode = .allVisible
        delegate = self
        
    }
    
    // MARK: UISplitViewControllerDelegate
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}
