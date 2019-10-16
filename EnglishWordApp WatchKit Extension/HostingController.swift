//
//  HostingController.swift
//  EnglishWordApp WatchKit Extension
//
//  Created by headspinnerd on 2019/10/14.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView(sentences: sentences)
    }
}
