//
//  SelectSentence.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/17.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import Foundation

class SelectSentence {
    static func findComparison(sentence: Sentence) -> (isHidden: Bool, consumption: Int) {
        var targetDate: Date
        var consumption = 0
        let lastAnsDate = sentence.lastAnsDate
        switch(sentence.status) {
            case .Forgot:
                // 1 hour later
                targetDate = Calendar.current.date(byAdding: .hour, value: 1, to: lastAnsDate)!
                consumption = 3
            case .NeverSeen:
                // now (no need to calculate)
                targetDate = Date()
                consumption = 4
            case .HitOnce, .HitThreeAfterFailed:
                // 1 week later
                targetDate = Calendar.current.date(byAdding: .day, value: 7, to: lastAnsDate)!
                consumption = 2
            case .Master:
                // never
                targetDate = Calendar.current.date(byAdding: .year, value: 100, to: lastAnsDate)!
            case .HitOnceAfterFailed:
                // 1 day later
                targetDate = Calendar.current.date(byAdding: .day, value: 1, to: lastAnsDate)!
                consumption = 2
            case .HitTwiceAfterFailed:
                // 3 days later
                targetDate = Calendar.current.date(byAdding: .day, value: 3, to: lastAnsDate)!
                consumption = 1
            case .HitFourAfterFailed:
                // 1 month later
                targetDate = Calendar.current.date(byAdding: .month, value: 1, to: lastAnsDate)!
                consumption = 1
        }
        if (Date().compare(targetDate) == .orderedAscending)
        {
            return (true, 0)
        }
        
        return (false, consumption)
    }
}
