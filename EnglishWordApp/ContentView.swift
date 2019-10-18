//
//  ContentView.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/14.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var sentences: [Sentence]
    
    var body: some View {
        VStack {
            List {
                ForEach(sentences, id: \.id) { sentence in
                    self.sentenceView(sentence: sentence)
                        .gesture(TapGesture(count: 2).exclusively(before: TapGesture(count: 1)).onEnded{ value in
                            switch value {
                                case .first():
                                    // if double tap
                                    if let row = self.sentences.firstIndex(where: {$0.id == sentence.id}) {
                                        let mode = sentence.mode ?? .Japanese
                                        if (mode == .Japanese) {
                                            return
                                        }
                                        self.sentences[row].mode = mode == .English ? .EnglishQuiz : .English
                                    }
                                case .second():
                                    // if single tap
                                    if let row = self.sentences.firstIndex(where: {$0.id == sentence.id}) {
                                        let mode = sentence.mode ?? .Japanese
                                        self.sentences[row].mode = mode == .Japanese ? .EnglishQuiz : .Japanese
                                    }
                        }
                    })
                }.onDelete(perform: delete)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            if (sentences[index].mode != .none) {
                sentences[index].lastAnsDate = Date()
            }
            
            if (sentences[index].mode == .Japanese || sentences[index].mode == .EnglishQuiz) {
                sentences[index].status = .HitOnce
            }
            else if (sentences[index].mode == .English) {
                sentences[index].status = .Master
            }
        }
//        sentences.remove(atOffsets: offsets)
    }
    
    func sentenceView(sentence: Sentence) -> AnyView? {            
        var result = Text("")
        let mode = sentence.mode ?? .Japanese
        if (mode == .Japanese) {
            result = Text(sentence.japanese)
        }
        else {
            sentence.words.forEach { word in
                if (mode == .English) {
                    switch(word.category) {
                        case .Easy:
                            result = result + Text(" \(word.word)")
                        case .JustInCase:
                            result = result + Text(" \(word.word)").foregroundColor(.blue)
                        case .Hard:
                            result = result + Text(" \(word.word)").foregroundColor(.blue).bold()
                        case .Punctuation:
                            result = result + Text("\(word.word)")
                        case .Special:
                            result = result + Text("\(word.word)").foregroundColor(.blue)
                    }
                }
                else if (mode == .EnglishQuiz) {
                    switch(word.category) {
                        case .Easy:
                            result = result + Text(" \(word.word)")
                        case .JustInCase:
                            result = result + Text(" \(word.word)").foregroundColor(.blue)
                        case .Hard:
                            result = result + Text(" ")
                            var consecutive = 0
                            for char in word.word {
                                if (char == " ") {
                                    result = result + Text(" ")
                                    consecutive = 0
                                }
                                else {
                                    result = result + Text("_").foregroundColor(.blue).bold()
                                    if (consecutive % 4 == 3) {
                                        result = result + Text("_").foregroundColor(.blue).bold()
                                    }
                                    consecutive += 1
                                }
                            }
                        case .Punctuation:
                            result = result + Text("\(word.word)")
                        case .Special:
                            result = result + Text("\(word.word)").foregroundColor(.blue).bold()
                    }
                }
            }
        }
        
        store(sentences: sentences)

        return AnyView(
            HStack {
                Text("\(sentence.id)").frame(minWidth: 20, maxWidth: 30, alignment: .leading)
                result
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sentences: sentences)
    }
}
