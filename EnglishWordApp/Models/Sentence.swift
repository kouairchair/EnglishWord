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
    var lastAnsDate: Date {
        get {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss" //2019-10-12T23:40:00Z
            let formattedDate = format.date(from: lastAnswerDate)
            return formattedDate ?? Date(timeIntervalSince1970: TimeInterval(0))
        }
        
        set(value) {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss" //2019-10-12T23:40:00Z
            let formattedDate = format.string(from: value)
            lastAnswerDate = formattedDate
        }
    }
    var mode: Mode?
    var words: [Word]
    var japanese: String
    
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
