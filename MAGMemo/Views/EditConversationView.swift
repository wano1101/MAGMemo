//
//  EditConversationView.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/26.
//

import SwiftUI

struct EditConversationView: View {
    @ObservedObject var viewModel: EditConversationViewModel
    @FocusState private var isMessageInputFocused: Bool
    
    var body: some View {
        VStack {
            messageListView()
            Divider()
            inputSectionView()
        }
        .navigationTitle("追加ステップ②", displayMode: .inline)
        .toolbar(content: toolbarContent)
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("完了", action: viewModel.handleDoneButtonTap)
                .disabled(viewModel.messages.isEmpty)
        }
    }
    
    @ViewBuilder
    private func messageListView() -> some View {
        ScrollView {
            ForEach(viewModel.messages) { message in
                messageRowView(message: message)
                    .padding()
            }
        }
        .onTapGesture {
            isMessageInputFocused = false
        }
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func messageRowView(message: Message) -> some View {
        switch message.speaker {
        case .myself:
            Text(message.comment)
                .padding()
                .background(.mainBlue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .contextMenu {
                    contextMenuView(for: message)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
        case .member:
            Text(message.comment)
                .padding()
                .background(.mainPink)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .contextMenu {
                    contextMenuView(for: message)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private func contextMenuView(for message: Message) -> some View {
        Button("編集") {
            viewModel.handleEditMessageButtonTap(message)
        }
        Button("削除", role: .destructive) {
            viewModel.handleDeleteMessageButtonTap(message)
        }
    }
    
    @ViewBuilder
    private func inputSectionView() -> some View {
        VStack {
            Picker("発言者を選択", selection: $viewModel.selectedSpeaker) {
                ForEach(Speaker.allCases) { speaker in
                    Text(speaker.rawValue)
                        .tag(speaker)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 8)
            HStack(alignment: .bottom, spacing: 8) {
                AutoGrowingTextEditorView(text: $viewModel.inputMessageText)
                    .focused($isMessageInputFocused)
                Button(viewModel.isEditingMessage ? "更新" : "送信", action: viewModel.handleSendMessageButtonTap)
            }
            if viewModel.isEditingMessage {
                Button("キャンセル", action:  viewModel.handleCancelEditMessageButtonTap)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
            }
        }
        .padding()
    }
}

#Preview {
    let previewMemo = MAGMemo(
        id: UUID().uuidString,
        userId: UUID().uuidString,
        memberName: "松田好花",
        eventName: "卒業ミーグリ 5部",
        eventDate: Date(),
        messages: [
            Message(id: UUID(), speaker: .member, comment: "ありがとう〜！"),
            Message(id: UUID(), speaker: .myself, comment: "こちらこそありがとう〜！")
        ]
    )
    NavigationStack {
        EditConversationView(viewModel: EditConversationViewModel(magMemo: previewMemo))
    }
}
