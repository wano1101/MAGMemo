//
//  MAGMemoDetailViewModel.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/04/02.
//

import SwiftUI

class MAGMemoDetailViewModel: ObservableObject {
    @Published var isShowingEditBasicInfoView = false
    @Published var isShowingDeleteAlert = false
    @Published var memo: MAGMemo
    private let memoRepository = MemoRepository()
    
    init(memo: MAGMemo) {
        self.memo = memo
    }
    
    func handleMenuEditButtonTap() {
        isShowingEditBasicInfoView = true
    }
    
    func handleMenuDeleteButtonTap() {
        isShowingDeleteAlert = true
    }
    
    @MainActor
    func handleDeleteButtonTap(completion: @escaping () -> Void) {
        Task {
            do {
                try await memoRepository.deleteMAGMemo(memo.id)
                completion()
            }
        }
    }
    
    @MainActor
    func fetchMemo() {
        Task {
            do {
                if let fetched = try await MemoRepository().fetchMAGMemo(by: memo.id) {
                    self.memo = fetched
                }
            } catch {
                print("メモの取得に失敗しました: \(error.localizedDescription)")
            }
        }
    }
}
