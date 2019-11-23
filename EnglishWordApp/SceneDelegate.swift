//
//  SceneDelegate.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/14.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import UIKit
import SwiftUI
import WatchConnectivity

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                fatalError("Unable to read managed object context.")
            }
            Constants.context = context
                    
            //test_tanaka
//            Vocabulary.clearVocabulary()
//            VocabWords.clearVocabWords()
//            InitialData.sentences.forEach { sentence in
//                Vocabulary(context: context).migrateFromSentence(sentence: sentence)
//            }
            let contentView = ContentView().environment(\.managedObjectContext, context).environmentObject(UserData())

            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
//        let vocabulary = Vocabulary.toDictionaries()
//        vocabulary.forEach { vocab in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                WCSession.sendMessage(vocab,
//                replyHandler: { replyDict in
//                    // リプライ
//                    print("")
//                },
//                errorHandler: { error in
//                    print(error.localizedDescription)}
//                )
//            }
//        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

