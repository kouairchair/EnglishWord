//
//  Sentence.swift
//  FirstWatchApp WatchKit Extension
//
//  Created by headspinnerd on 2019/10/12.
//  Copyright © 2019 Koki Tanaka. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Sentence: Hashable, Codable, Identifiable {
    var id: Int
    var book: Int
    var section: Int
    var status: Status
    fileprivate var lastAnswerDate: String
    var mode: Mode?
    var words: [Word]
    var japanese: String

    enum Status: Int, CaseIterable, Codable, Hashable {
        case NeverSeen = 0
        case JustSeen = 1
        case Memorized = 2
    }
    
    enum Mode: Int, CaseIterable, Codable, Hashable {
        case Japanese = 0
        case English = 1
        case EnglishQuiz = 2
    }
}

struct Word: Hashable, Codable {
    var word: String
    var category: Category
    
    enum Category: Int, CaseIterable, Codable, Hashable {
        case Punctuation = -1
        case Easy = 0
        case JustInCase = 1
        case Hard = 2
        case Special = 3
    }
}
