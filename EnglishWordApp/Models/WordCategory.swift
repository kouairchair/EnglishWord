//
//  WordCategory.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/11/03.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import Foundation

public enum WordCategory: Int, CaseIterable, Codable, Hashable {
    case Punctuation = -1
    case Easy = 0
    case JustInCase = 1
    case Hard = 2
    case Special = 3
}
