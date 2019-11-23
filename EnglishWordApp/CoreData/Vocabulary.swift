//
//  Vocabulary+CoreDataClass.swift
//  
//
//  Created by headspinnerd on 2019/10/20.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Vocabulary)
public class Vocabulary: NSManagedObject, Identifiable {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vocabulary> {
//        return NSFetchRequest<Vocabulary>(entityName: "Vocabulary")
//    }
    @NSManaged public var bookId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var japanese: String?
    @NSManaged public var lastAnswerDate: NSDate?
    @NSManaged public var mode: Int16
    @NSManaged public var section: Int16
    @NSManaged public var status: Int16
    @NSManaged public var children: NSSet?
}
