//
//  MAGMemoListView.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/18.
//

import SwiftUI

struct MAGMemoListView: View {
    @StateObject private var viewModel = MAGMemoListViewModel()
    
    var body: some View {
        NavigationStack {
            memoListView(memos: viewModel.memos)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.backgroundBlue)
                .navigationTitle("ミーグリメモ")
                .toolbar(content: toolbarContent)
                .onAppear {
                    viewModel.fetchMemos()
                }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: viewModel.showEditBasicInfoView) {
                Image(systemName: "plus")
            }
            .fullScreenCover(isPresented: $viewModel.isShowingEditBasicInfoView, onDismiss: viewModel.fetchMemos) {
                EditBasicInfoView()
            }
        }
    }
    
    @ViewBuilder
    private func memoListView(memos: [MAGMemo]) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(memos) { memo in
                    memoCardView(memo: memo)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func memoCardView(memo: MAGMemo) -> some View {
        NavigationLink(destination: MAGMemoDetailView(memo: memo)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(memo.memberName)
                            .font(.headline.bold())
                        Spacer()
                        Text(memo.eventName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text(memo.eventDate, style: .date)
                        .foregroundStyle(.secondary)
                        .frame(maxHeight: .infinity, alignment: .topTrailing)
                }
                VStack(spacing: 2) {
                    ForEach(memo.messages.prefix(5)) { message in
                        messageBubble(message: message)
                    }
                }
                .padding()
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func messageBubble(message: Message) -> some View {
        switch message.speaker {
        case.member:
            Text(message.comment)
                .padding(8)
                .background(.mainPink)
                .foregroundStyle(.white)
                .font(.caption2.bold())
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 50)
                .lineLimit(3)
        case.myself:
            Text(message.comment)
                .padding(8)
                .background(.mainBlue)
                .foregroundStyle(.white)
                .font(.caption2.bold())
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.leading, 50)
                .lineLimit(3)
        }
    }
}

#Preview {
    MAGMemoListView()
}
