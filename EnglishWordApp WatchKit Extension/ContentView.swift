//
//  ContentView.swift
//  FirstWatchApp WatchKit Extension
//
//  Created by Koki Tanaka on 2019/09/27.
//  Copyright © 2019 Koki Tanaka. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//@FetchRequest(fetchRequest: Vocabulary.allVocabularyFetchReq()) var sentences: FetchedResults<Vocabulary>
    @State var sentences: [Sentence]
    
    var body: some View {
        VStack
        {
            List {
                ForEach(sentences, id: \.self) { sentence in
                    self.sentenceView(sentence: sentence)
                        .gesture(TapGesture(count: 2).exclusively(before: TapGesture(count: 1)).onEnded{ value in
                            switch value {
                                case .first():
                                    // if double tap
                                    if let row = self.sentences.firstIndex(where: {$0.id == sentence.id}) {
                                        let mode = sentence.mode
                                        if (mode == .Japanese) {
                                            return
                                        }
                                        let toMode: CurrentMode = mode == .English ? .EnglishQuiz : .English
                                        self.sentences[row].mode = toMode
                                    }
                                case .second():
                                    // if single tap
                                    if let row = self.sentences.firstIndex(where: {$0.id == sentence.id}) {
                                        let mode = sentence.mode
                                        let toMode: CurrentMode = mode == .Japanese ? .EnglishQuiz : .Japanese
                                        self.sentences[row].mode = toMode
                                    }
                        }
                    })
                }
            }
        }
    }
    
    func sentenceView(sentence: Sentence) -> AnyView? {
        var result = Text("")
        let mode = sentence.mode
        if (mode == .Japanese) {
            result = Text(sentence.japanese)
        }
        else {
//            if let words = sentence.fetchChildren() {
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
//            }
//            else {
//                result = Text(sentence.japanese ?? "")
//            }
        }
        
        InitialData.store(sentences: sentences)

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
        ContentView(sentences: InitialData.sentences)
    }
}
