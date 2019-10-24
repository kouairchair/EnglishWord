//
//  VocabWords+CoreDataProperties.swift
//  
//
//  Created by headspinnerd on 2019/10/22.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension VocabWords {
    
    var _category: Category {
        get { return Category(rawValue: Int(self.category)) ?? .Easy }
        set { self.category = Int16(newValue.rawValue) }
    }
    
    enum Category: Int, CaseIterable, Codable, Hashable {
        case Punctuation = -1
        case Easy = 0
        case JustInCase = 1
        case Hard = 2
        case Special = 3
    }
    
    var _word: String {
        return word ?? ""
    }
    
    func storeWords() {
        guard let wordsEntity = NSEntityDescription.entity(forEntityName: "VocabWords", in: Constants.context) else {
            fatalError("Unable to read NSEntityDescription.")
        }
        guard let managedVocabularyObj = NSManagedObject(entity: wordsEntity, insertInto: Constants.context) as? VocabWords else { fatalError("Unable to read managed object context.") }
        
        managedVocabularyObj.setValue(self.category, forKey: "category")
        managedVocabularyObj.setValue(self.fkey, forKey: "fkey")
        managedVocabularyObj.setValue(self.orderNo, forKey: "orderNo")
        managedVocabularyObj.setValue(self.word, forKey: "word")

        do {
            try Constants.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Clear Vocabulary Words Data
    static func clearVocabWords() {
        let fetchRequest:NSFetchRequest<VocabWords> = VocabWords.fetchRequest()

        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)

        do {
            print("deleting all Vocabulary words data")
            try Constants.context.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }

}
