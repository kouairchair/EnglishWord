//
//  Constants.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/16.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import Foundation
import CoreData

public struct Constants {
    enum Data : String {
        case sentence
    }
    static var _context: NSManagedObjectContext?
    static var context: NSManagedObjectContext {
        get {
            guard let unwrappedContext = _context else
                { fatalError("Unable to read managed object context.") }
            return unwrappedContext
        }
        set(value) {
            _context = value
        }
    }
}
