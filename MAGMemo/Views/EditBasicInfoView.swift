//
//  EditBasicInfoView.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/25.
//

import SwiftUI

struct EditBasicInfoView: View {
    @StateObject private var viewModel = EditBasicInfoViewModel()
    
    init(magMemo: MAGMemo? = nil) {
        if let magMemo {
            _viewModel = StateObject(wrappedValue: EditBasicInfoViewModel(
                magMemo: magMemo
            ))
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    TextField("アイドル名を入力", text: $viewModel.magMemo.memberName)
                        .focused($isTextFieldFocused)
                    TextField("イベント名を入力", text: $viewModel.magMemo.eventName)
                    DatePicker("日付", selection: $viewModel.magMemo.eventDate, displayedComponents: .date)
                }
            }
            .navigationTitle("追加ステップ①", displayMode: .inline)
            .toolbar(content: toolbarContent)
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("閉じる") {
                dismiss()
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(
                "次へ",
                destination: EditConversationView(
                    viewModel: EditConversationViewModel(magMemo: viewModel.magMemo)
                )
            )
            .disabled(!viewModel.canProceedToNext)
        }
    }
}

#Preview {
    EditBasicInfoView()
}
