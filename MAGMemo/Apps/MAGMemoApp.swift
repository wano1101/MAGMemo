//
//  MAGMemoApp.swift
//  MAGMemo
//
//  Created by RikutoSato on 2025/03/11.
//

import SwiftUI

@main
struct MAGMemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MAGMemoListView()
        }
    }
}
