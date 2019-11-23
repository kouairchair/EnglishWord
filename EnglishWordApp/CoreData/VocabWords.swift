//
//  VocabWords+CoreDataClass.swift
//  
//
//  Created by headspinnerd on 2019/10/22.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(VocabWords)
public class VocabWords: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabWords> {
        return NSFetchRequest<VocabWords>(entityName: "VocabWords")
    }

    @NSManaged public var category: Int16
    @NSManaged public var fkey: Int16
    @NSManaged public var orderNo: Int16
    @NSManaged public var word: String?
    @NSManaged public var parent: Vocabulary?
}
