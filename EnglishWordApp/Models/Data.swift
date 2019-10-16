//
//  Data.swift
//  FirstWatchApp WatchKit Extension
//
//  Created by headspinnerd on 2019/10/13.
//  Copyright © 2019 Koki Tanaka. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI
import ImageIO

var sentences: [Sentence]
{
    var _sentences: [Sentence] = load("Sentences.geojson")
    _sentences.sort(by: { $1.id > $0.id })
    return _sentences
}
    
//let features = landmarkData.filter { $0.isFeatured }

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
