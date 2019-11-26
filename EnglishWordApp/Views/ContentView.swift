//
//  ContentView.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/14.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    @State var sentences: [Vocabulary]
    @FetchRequest(fetchRequest: Vocabulary.allVocabularyFetchReq()) var _sentences: FetchedResults<Vocabulary>
    @State private var showingAdvancedOptions = false
    @State private var displayMode = 0
    
    var sentences: [Vocabulary] {
        return SelectVocabulary.filterTodaysItem(sentences: _sentences)
    }
    
    var body: some View {
        VStack {
//            Toggle(isOn: $showingAdvancedOptions) {
//                Text("Registration Mode").padding(20)
//            }.frame(height: 30)
            Picker(selection: $displayMode, label: Text("What is your favorite color?")) {
                Text("List").tag(0)
                Text("Create").tag(1)
                Text("Edit").tag(2)
            }.pickerStyle(SegmentedPickerStyle())

            if displayMode == 1 {
                CreateView().frame(height: 200)
            }
            List {
                ForEach(self.sentences, id: \.self) { sentence in
                    self.sentenceView(sentence: sentence)
                        .gesture(TapGesture(count: 2).exclusively(before: TapGesture(count: 1)).onEnded{ value in
                            switch value {
                                case .first():
                                    // if double tap
                                    if let row = self.sentences.firstIndex(where: {$0.id == sentence.id}) {
                                        let mode = sentence._mode
                                        if (mode == .Japanese) {
                                            return
                                        }
                                        let toMode: CurrentMode = mode == .English ? .EnglishQuiz : .English
                                        self.sentences[row].editMode(toMode: toMode)
                                    }
                                case .second():
                                    // if single tap
                                    if let row = self.sentences.firstIndex(where: {$0.id == sentence.id}) {
                                        let mode = sentence._mode
                                        let toMode: CurrentMode = mode == .Japanese ? .EnglishQuiz : .Japanese
                                        self.sentences[row].editMode(toMode: toMode)
                                    }
                        }
                    })
                }.onDelete(perform: correct)
            }
        }
    }
    
    func correct(at offsets: IndexSet) {
        offsets.forEach { index in
            sentences[index].changeStatusWhenCorrect()
            sentences[index].updateLastAnswerDate()
        }
//        sentences.remove(atOffsets: offsets)
    }
    
    func wrong(offsets: IndexSet) {
        offsets.forEach { index in
            sentences[index].changeStatusWhenWrong()
            sentences[index].updateLastAnswerDate()
        }
    }
    
    func sentenceView(sentence: Vocabulary) -> AnyView? {
        var result = Text("")
        let mode = sentence._mode
        if (mode == .Japanese) {
            result = Text(sentence.japanese ?? "")
        }
        else {
            if let words = sentence.fetchChildren() {
                words.forEach { word in
                    if (mode == .English) {
                        switch(word._category) {
                            case .Easy:
                                result = result + Text(" \(word._word)")
                            case .JustInCase:
                                result = result + Text(" \(word._word)").foregroundColor(.blue)
                            case .Hard:
                                result = result + Text(" \(word._word)").foregroundColor(.blue).bold()
                            case .Punctuation:
                                result = result + Text("\(word._word)")
                            case .Special:
                                result = result + Text("\(word._word)").foregroundColor(.blue)
                        }
                    }
                    else if (mode == .EnglishQuiz) {
                        switch(word._category) {
                            case .Easy:
                                result = result + Text(" \(word._word)")
                            case .JustInCase:
                                result = result + Text(" \(word._word)").foregroundColor(.blue)
                            case .Hard:
                                result = result + Text(" ")
                                var consecutive = 0
                                for char in word._word {
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
                                result = result + Text("\(word._word)")
                            case .Special:
                                result = result + Text("\(word._word)").foregroundColor(.blue).bold()
                        }
                    }
                }
            }
            else {
                result = Text(sentence.japanese ?? "")
            }
        }
        
//        InitialData.store(sentences: sentences)

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
        ContentView()
    }
}
