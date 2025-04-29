//
//  AppDelegate.swift
//  MAGMemo
//
//  Created by RikutoSato on 2025/04/25.
//

import FirebaseCore
import FirebaseAuth
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        authSignInAnonymously()
        return true
    }

    private func authSignInAnonymously() {
        let us = UserDefaults.standard

        if let uid = us.string(forKey: ConstantData.userId) {
            Auth.auth().signIn(withCustomToken: uid) { _, error in
                if let error = error {
                    print("Auth Error: \(error.localizedDescription)")
                }
            }
        } else {
            Auth.auth().signInAnonymously() { authResult, error in
                if let error = error {
                    print("Auth Error: \(error.localizedDescription)")
                    return
                }
                if let user = authResult?.user {
                    us.set(user.uid, forKey: ConstantData.userId)
                }
            }
        }
    }
}
