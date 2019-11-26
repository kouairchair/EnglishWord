//
//  CoreDataExtension.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/19.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import UIKit
import CoreData
import SwiftUI

public extension Vocabulary {
    @objc(addChildrenObject:)
    @NSManaged func addToChildren(_ value: VocabWords)

    @objc(removeChildrenObject:)
    @NSManaged func removeFromChildren(_ value: VocabWords)

    @objc(addChildren:)
    @NSManaged func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged func removeFromChildren(_ values: NSSet)
    
    // ❇️ The @FetchRequest property wrapper in the ContentView will call this function
    static func allVocabularyFetchReq() -> NSFetchRequest<Vocabulary> {
        let request: NSFetchRequest<Vocabulary> = Vocabulary.fetchRequest() as! NSFetchRequest<Vocabulary>
        
//        let predicateFormat = """
//            \(#keyPath(Vocabulary.status)) == \(StudyStatus.NeverSeen.rawValue)
//            || \(#keyPath(Vocabulary.status)) == \(StudyStatus.Forgot.rawValue)
//            || (\(#keyPath(Vocabulary.status)) == \(StudyStatus.HitOnce.rawValue)
//                && \(#keyPath(Vocabulary.lastAnswerDate)) <= %@ )
//        """
//        request.predicate = NSPredicate(format: predicateFormat, Date.someDaysAgo(days: 7))

        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "status", ascending: true), NSSortDescriptor(key: "id", ascending: true)]
        
        return request
    }
    
    func fetchChildren() -> [VocabWords]? {
        let fetchRequest:NSFetchRequest<VocabWords> = VocabWords.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "parent == %@", self)
        var fetchData: [VocabWords]?
        do {
            fetchData = try Constants.context.fetch(fetchRequest)
            return fetchData
        } catch {
            return nil
        }
    }
    
    static func toDictionaries() -> [[String: Any]] {
        var result = [[String: Any]]()
        let keys = Array(self.entity().attributesByName.keys)
        var vocabulary = [Vocabulary]()
        do {
            vocabulary = try Constants.context.fetch(self.allVocabularyFetchReq())
        } catch {
            fatalError("error")
        }
        vocabulary.forEach { vocab in
            result.append(vocab.dictionaryWithValues(forKeys: keys))
        }
        return result
    }
    
    func editMode(toMode: CurrentMode) {
        _mode = toMode
        saveContext()
    }
    
    var _lastAnswerDate: NSDate {
        get {
            return lastAnswerDate ?? NSDate(timeIntervalSince1970: TimeInterval(0))
        }
        set(value) {
            lastAnswerDate = value ?? Date(timeIntervalSince1970: TimeInterval(0)))
        }
    }
    
    var _status: StudyStatus {
        get { return StudyStatus(rawValue: Int(self.status)) ?? .NeverSeen }
        set {
            self.status = Int16(newValue.rawValue)
            saveContext()
        }
    }
    
    var _mode: CurrentMode {
        get { return CurrentMode(rawValue: Int(self.mode)) ?? .Japanese }
        set {
            self.mode = Int16(newValue.rawValue)
            saveContext()
        }
    }
    
// -> このメソッドは不要？
//    func storeVocabulary() -> Void {
//        guard let context = Constants.context else { fatalError("Unable to read managed object context.") }
//        guard let vocabularyEntity = NSEntityDescription.entity(forEntityName: "Vocabulary", in: context) else {
//            fatalError("Unable to read NSEntityDescription.")
//        }
//        guard let managedVocabularyObj = NSManagedObject(entity: vocabularyEntity, insertInto: context) as? Vocabulary else { fatalError("Unable to read managed object context.") }
//
//        managedVocabularyObj.setValue(self.id, forKey: "id")
//        managedVocabularyObj.setValue(self.bookId, forKey: "bookId")
//        managedVocabularyObj.setValue(self.japanese, forKey: "japanese")
//        managedVocabularyObj.setValue(self.lastAnswerDate, forKey: "lastAnswerDate")
//        managedVocabularyObj.setValue(self.mode, forKey: "mode")
//        managedVocabularyObj.setValue(self.section, forKey: "section")
//        managedVocabularyObj.setValue(self.status, forKey: "status")
////        managedVocabularyObj.setValue(self.parent, forKey: "parent")
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    // Clear Vocabulary Data
    static func clearVocabulary() {
        let fetchRequest:NSFetchRequest<Vocabulary> = Vocabulary.allVocabularyFetchReq()

        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)

        do {
            print("deleting all Vocabulary data")
            try Constants.context.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func changeStatusWhenCorrect() {
        switch(_status) {
            case .Forgot:
                _status = .HitOnceAfterFailed
            case .HitOnce:
                _status = .Master
            case .HitOnceAfterFailed:
                _status = .HitTwiceAfterFailed
            case .HitTwiceAfterFailed:
                _status = .HitThreeAfterFailed
            case .HitThreeAfterFailed:
                _status = .HitFourAfterFailed
            case .HitFourAfterFailed:
                _status = .Master
            case .NeverSeen:
                _status = .HitOnce
            case .Master:
                _status = .Master
        }
        saveContext()
    }
    
    func changeStatusWhenWrong() {
        _status = .Forgot
        saveContext()
    }
    
    func updateLastAnswerDate() {
        _lastAnswerDate = NSDate(timeInterval: TimeInterval(0), 
           since: Constants.dateFormatter.date(from: Date())
        saveContext()
    }
    
    func saveContext() {
        do {
            try Constants.context.save()
        } catch {
            print(error)
        }
    }
    
    func migrateFromSentence(sentence: Sentence) -> Void {
        self.id = Int16(sentence.id)
        self.bookId = Int16(sentence.book)
        self.japanese = sentence.japanese
        self.mode = Int16(sentence.mode?.rawValue ?? 0)
        self.section = Int16(sentence.section)
        self.status = Int16(sentence.status.rawValue)
        self.lastAnswerDate = sentence.lastAnsDate
        
        do {
            try Constants.context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        var index = 1
        sentence.words.forEach { word in
            let _word = VocabWords(context: Constants.context)
            _word.category = Int16(word.category.rawValue)
//            _word.fkey = word.fkey
            _word.orderNo = Int16(index)
            _word.word = word.word
            index += 1
            _word.storeWords()
            self.addToChildren(_word)
        }
        
        
//        self.parent = words
//        storeVocabulary()
    }
}
