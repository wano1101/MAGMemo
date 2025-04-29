//
//  MAGMemoListViewModel.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/26.
//

import SwiftUI

class MAGMemoListViewModel: ObservableObject {
    @Published var memos: [MAGMemo] = []
    @Published var isShowingEditBasicInfoView = false
    
    private let memoRepository = MemoRepository()
    
    init() {
        fetchMemos()
    }
    
    func showEditBasicInfoView() {
        isShowingEditBasicInfoView = true
    }
    
    func fetchMemos() {
        Task {
            do {
                let fetched = try await memoRepository.fetchMAGMemos()
                self.memos = fetched
            } catch {
                print("メモの取得に失敗しました: \(error.localizedDescription)")
            }
        }
    }
}
