//
//  ContentView.swift
//  FirstWatchApp WatchKit Extension
//
//  Created by Koki Tanaka on 2019/09/27.
//  Copyright © 2019 Koki Tanaka. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    @State var sentences: [Sentence]
    
    var body: some View {
        VStack
        {
            List(InitialData.sentences, id: \.id) { sentence in
                self.sentenceView(sentence: sentence)
                    .gesture(SimultaneousGesture(
                        TapGesture().onEnded({
                            if let row = InitialData.sentences.firstIndex(where: {$0.id == sentence.id}) {
                                let mode = sentence.mode ?? .Japanese
                                InitialData.sentences[row].mode = mode == .Japanese ? .English : .Japanese
                            }
                        }),
                        TapGesture(count: 2).onEnded({_ in
                            if let row = InitialData.sentences.firstIndex(where: {$0.id == sentence.id}) {
                                InitialData.sentences[row].id = InitialData.sentences[row].id - 1
                            }
                    })))
            }
        }
    }
    
    func sentenceView(sentence: Sentence) -> AnyView {
        var result = Text("\(sentence.id) ")
        let mode = sentence.mode ?? .Japanese
        if (mode == .Japanese)
        {
            return AnyView(result + Text(sentence.japanese))
        }
        sentence.words.forEach { word in
            switch(word.category)
            {
                case .Easy:
                    result = result + Text(" \(word.word)")
                case .JustInCase:
                    result = result + Text(" \(word.word)").foregroundColor(.blue)
                case .Hard:
                    result = result + Text(" \(word.word)").foregroundColor(.blue).bold()
                case .Punctuation:
                    result = result + Text("\(word.word)")
                case .Special:
                    result = result + Text("\(word.word)").foregroundColor(.blue).bold()
            }
        }
        return AnyView(result)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
