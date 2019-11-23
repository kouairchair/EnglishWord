//
//  CurrentMode.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/11/03.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import Foundation

public enum CurrentMode: Int, CaseIterable, Codable, Hashable {
    case Japanese = 0
    case English = 1
    case EnglishQuiz = 2
}
