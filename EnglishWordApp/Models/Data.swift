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
    if let _sentences = load() {
        return _sentences
    }
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

func store(sentences: [Sentence]) {
    UserDefaults.standard.set(parseToJson(sentences: sentences), forKey: Constants.Data.sentence.rawValue)
}

func load() -> [Sentence]? {
    if let jsonString = UserDefaults.standard.string(forKey: Constants.Data.sentence.rawValue), let jsonData: Data = jsonString.data(using: String.Encoding.utf8)
    {
        do {
            let decoder = JSONDecoder()
            let items = try decoder.decode([Sentence].self, from: jsonData)
            return items
        } catch {
            return nil
        }
    }
    
    return nil
}

func parseToJson(sentences: [Sentence]) -> String {
    do {
        // [Sentence]をJSONデータに変換
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(sentences)
        // JSONデータを文字列に変換
        let jsonStr = String(bytes: jsonData, encoding: .utf8)!
        return jsonStr
    } catch (let e) {
        fatalError("fatalError:\(e.localizedDescription)")
    }
}
