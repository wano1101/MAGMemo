//
//  AutoGrowingTextEditorView.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/04/09.
//

import SwiftUI

struct AutoGrowingTextEditorView: View {
    @Binding var text: String
    @State private var textEditorHeight: CGFloat = 40

    var body: some View {
        TextEditor(text: $text)
            .frame(height: textEditorHeight)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .onChange(of: text) {
                adjustTextEditorHeight()
            }
    }

    private func adjustTextEditorHeight() {
        let baseHeight: CGFloat = 40
        let lineHeight: CGFloat = 25
        let maxLines: CGFloat = 4

        let numberOfLines = CGFloat(text.components(separatedBy: .newlines).count)
        let totalLines = min(numberOfLines, maxLines)

        let newHeight = baseHeight + (totalLines - 1) * lineHeight

        if newHeight != textEditorHeight {
            textEditorHeight = newHeight
        }
    }
}
