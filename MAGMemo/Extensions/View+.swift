//
//  View+.swift
//  MAGMemo
//
//  Created by RikutoSato on 2025/03/28.
//

import SwiftUI

extension View {
    func navigationTitle(_ title: String, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(displayMode)
    }
}
