//
//  WCSessionExtension.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/28.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import Foundation
import WatchConnectivity

public extension WCSession {
    static func sendMessage(_ message: [String: Any],
                                     replyHandler: (([String: Any]) -> Void)?,
                                     errorHandler: ((Error) -> Void)?) {
        /* The following trySendingMessageToWatch sometimews fails with
        Error Domain=WCErrorDomain Code=7007 "WatchConnectivity session on paired device is not reachable."
        In this case, the transfer is retried a number of times.
        */
        let maxNrRetries = 5
        var availableRetries = maxNrRetries

        func trySendingMessageToWatch(_ message: [String: Any]) {
            WCSession.default.sendMessage(message,
                  replyHandler: replyHandler,
                  errorHandler: { error in
                                  print("sending message to watch failed: error: \(error)")
                                  let nsError = error as NSError
                                  if nsError.domain == "WCErrorDomain" && nsError.code == 7007 && availableRetries > 0 {
                                     availableRetries = availableRetries - 1
                                    let randomDelay = Double.random(in: (0.3...1.0))
                                     DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay, execute: {
                                        trySendingMessageToWatch(message)
                                     })
                                   } else {
                                     errorHandler?(error)
                                   }
            })
        } // trySendingMessageToWatch

        trySendingMessageToWatch(message)
    } // sendMessage
}
