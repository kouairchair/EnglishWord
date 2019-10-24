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

        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

//        var stamina = 10
//
//        let _sentences = sentences.filter({ (value: Vocabulary) -> Bool in
//            let comparison = SelectVocabulary.findComparison(vacabulary: value)
//            if (comparison.isHidden) { return false }
//            if (stamina <= 0) { return false }
//            stamina -= comparison.consumption
//            return true
//        })
        
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
    
    func editMode(toMode: Mode) {
        _mode = toMode
        saveContext()
    }
    
    var _lastAnswerDate: Date {
        get {
            return lastAnswerDate ?? Date(timeIntervalSince1970: TimeInterval(0))
        }
    }
    
    var _status: Status {
        get { return Status(rawValue: Int(self.status)) ?? .NeverSeen }
        set { self.status = Int16(newValue.rawValue) }
    }
    
    enum Status: Int, CaseIterable, Codable, Hashable {
           case Forgot = -1 // 1回目正解、2回目不正解または1回目不正解（1時間後に再出題対象）
           case NeverSeen = 0 // 未出題（必ず出題対象）
           case HitOnce = 1 // 1回のみ出題で正解（7日後に再出題対象）
           case Master = 2 // 2回連続正解または不正解の後に5回連続正解（3回目の出題はなし）
           case HitOnceAfterFailed = 3 // 不正解の後に1回正解（1日後に再出題対象）
           case HitTwiceAfterFailed = 4 // 不正解の後に2回連続正解（3日後に再出題対象）
           case HitThreeAfterFailed = 5 // 不正解の後に3回連続正解（7日後に再出題対象）
           case HitFourAfterFailed = 6 // 不正解の後に4回連続正解（30日後に再出題対象）
       }
    
    var _mode: Mode {
        get { return Mode(rawValue: Int(self.mode)) ?? .Japanese }
        set { self.mode = Int16(newValue.rawValue) }
    }
    
    enum Mode: Int, CaseIterable, Codable, Hashable {
        case Japanese = 0
        case English = 1
        case EnglishQuiz = 2
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
        self.lastAnswerDate = sentence.lastAnsDate
        self.mode = Int16(sentence.mode?.rawValue ?? 0)
        self.section = Int16(sentence.section)
        self.status = Int16(sentence.status.rawValue)
        
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
