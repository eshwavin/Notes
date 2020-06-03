//
//  Utilities.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 01/06/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: AnyObject {
    func containsObjectIdentical(to object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}
