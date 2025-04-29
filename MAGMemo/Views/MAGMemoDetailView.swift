//
//  MAGMemoDetailView.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/29.
//

import SwiftUI

struct MAGMemoDetailView: View {
    @StateObject private var viewModel: MAGMemoDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(memo: MAGMemo) {
        _viewModel = StateObject(wrappedValue: MAGMemoDetailViewModel(memo: memo))
    }

    var body: some View {
        ScrollView {
            VStack {
                memoCardView(memo: viewModel.memo)
                Divider()
                messageListView(messages: viewModel.memo.messages)
            }
            .navigationTitle("メモ詳細", displayMode: .inline)
            .toolbar(content: toolbarContent)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingEditBasicInfoView, onDismiss: viewModel.fetchMemo) {
            EditBasicInfoView(magMemo: viewModel.memo)
        }
        .alert("このメモを削除しますか？", isPresented: $viewModel.isShowingDeleteAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("削除", role: .destructive) {
                viewModel.handleDeleteButtonTap {
                    DispatchQueue.main.async {
                        dismiss()
                    }
                }
            }
        } message: {
            Text("この操作は元に戻せません。")
        }
    }

    @ViewBuilder
    private func memoCardView(memo: MAGMemo) -> some View {
        VStack(alignment: .leading) {
            Text(memo.memberName)
                .font(.title2.bold())
            Text(memo.eventName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(memo.eventDate, style: .date)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    @ViewBuilder
    private func messageListView(messages: [Message]) -> some View {
        ForEach(messages) { message in
            messageBubbleView(message: message)
        }
        .padding()
    }

    @ViewBuilder
    private func messageBubbleView(message: Message) -> some View {
        switch message.speaker {
        case.member:
            Text(message.comment)
                .padding(12)
                .background(.mainPink)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
        case.myself:
            Text(message.comment)
                .padding(12)
                .background(.mainBlue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button(action: viewModel.handleMenuEditButtonTap) {
                    Label("編集", systemImage: "pencil")
                }
                Button(role: .destructive, action: viewModel.handleMenuDeleteButtonTap) {
                    Label("削除", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }
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

    return MAGMemoDetailView(memo: previewMemo)
}
