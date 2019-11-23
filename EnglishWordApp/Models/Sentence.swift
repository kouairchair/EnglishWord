//
//  Sentence.swift
//  FirstWatchApp WatchKit Extension
//
//  Created by headspinnerd on 2019/10/12.
//  Copyright © 2019 Koki Tanaka. All rights reserved.
//

import SwiftUI
import CoreLocation

public struct Sentence: Hashable, Codable, Identifiable {
    public var id: Int
    var book: Int
    var section: Int
    var status: StudyStatus
    fileprivate var lastAnswerDate: String
    var lastAnsDate: NSDate {
        get {
            let formattedDate = NSDate(timeInterval: TimeInterval(0), since: Constants.dateFormatter.date(from: lastAnswerDate) ?? Date(timeIntervalSince1970: TimeInterval(0)))
            return formattedDate
        }
        
        set(value) {
            let formattedDate = Constants.dateFormatter.string(from: value as Date)
            lastAnswerDate = formattedDate
        }
    }
    var mode: CurrentMode?
    var words: [Word]
    var japanese: String
}

struct Word: Hashable, Codable {
    var word: String
    var category: WordCategory
}
