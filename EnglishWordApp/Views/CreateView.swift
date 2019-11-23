//
//  CreateView.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/31.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import SwiftUI

struct CreateView: View {
    @State private var newSentence = ""
    
    var body: some View {
        List {
            Section(header: Text("New Sentence")) {
                HStack {
                    TextField("New Sentence", text: self.$newSentence)
                    Button(action: {
                        print("")
                    }){
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
