//
//  SelectSentence.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/17.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import Foundation
import SwiftUI

public class SelectVocabulary {
    static func filterTodaysItem(sentences: FetchedResults<Vocabulary>) -> [Vocabulary] {
        var stamina = UserData().maxStamina
        return sentences.filter({ (value: Vocabulary) -> Bool in
            let comparison = SelectVocabulary.findComparison(vocabulary: value)
            if (comparison.isHidden) { return false }
            if (stamina <= 0) { return false }
            stamina -= comparison.consumption
            return true
        })
    }
    
    static func findComparison(vocabulary: Vocabulary) -> (isHidden: Bool, consumption: Int) {
        var targetDate: Date
        var consumption = 0
        let lastAnsDate = vocabulary._lastAnswerDate
        switch(vocabulary._status) {
            case .Forgot:
                // 1 hour later
                targetDate = Calendar.current.date(byAdding: .hour, value: 1, to: lastAnsDate as Date)!
                consumption = 3
            case .NeverSeen:
                // now (no need to calculate)
                targetDate = Date()
                consumption = 4
            case .HitOnce, .HitThreeAfterFailed:
                // 1 week later
                targetDate = Calendar.current.date(byAdding: .day, value: 7, to: lastAnsDate as Date)!
                consumption = 2
            case .Master:
                // never
                targetDate = Calendar.current.date(byAdding: .year, value: 100, to: lastAnsDate as Date)!
            case .HitOnceAfterFailed:
                // 1 day later
                targetDate = Calendar.current.date(byAdding: .day, value: 1, to: lastAnsDate as Date)!
                consumption = 2
            case .HitTwiceAfterFailed:
                // 3 days later
                targetDate = Calendar.current.date(byAdding: .day, value: 3, to: lastAnsDate as Date)!
                consumption = 1
            case .HitFourAfterFailed:
                // 1 month later
                targetDate = Calendar.current.date(byAdding: .month, value: 1, to: lastAnsDate as Date)!
                consumption = 1
        }
        if (Date().compare(targetDate) == .orderedAscending)
        {
            return (true, 0)
        }
        
        return (false, consumption)
    }
}
