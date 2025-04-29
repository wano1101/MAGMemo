//
//  EditConversationViewModel.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/27.
//

import SwiftUI

class EditConversationViewModel: ObservableObject {
    @Published var inputMessageText = ""
    @Published var messages: [Message] = []
    @Published var selectedSpeaker: Speaker = .member
    @Published var editingMessage: Message? = nil
    @Published var magMemo: MAGMemo
    
    private let memoRepository = MemoRepository()
    
    init(magMemo: MAGMemo) {
        self.magMemo = magMemo
        self.messages = magMemo.messages
    }
    
    var isEditingMessage: Bool {
        editingMessage != nil
    }
    
    func handleSendMessageButtonTap() {
        if isEditingMessage {
            updateEditingMessage()
            return
        }
        guard !inputMessageText.isEmpty else { return }
        let newMessage = Message(id: UUID(), speaker: selectedSpeaker, comment: inputMessageText)
        messages.append(newMessage)
        inputMessageText = ""
    }
    
    func handleDoneButtonTap() {
        saveMemo(completion: dismissView)
    }
    
    private func dismissView() {
        DispatchQueue.main.async {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first?
                .rootViewController?
                .dismiss(animated: true)
        }
    }
    
    private func saveMemo(completion: @escaping () -> Void) {
        magMemo.messages = messages
        Task {
            do {
                try await memoRepository.saveMAGMemo(magMemo)
                completion()
            } catch {
                print("メモの保存に失敗しました: \(error.localizedDescription)")
            }
        }
    }
    
    func handleDeleteMessageButtonTap(_ message: Message) {
        messages.removeAll { $0.id == message.id }
    }
    
    func handleEditMessageButtonTap(_ message: Message) {
        editingMessage = message
        inputMessageText = message.comment
        selectedSpeaker = message.speaker
    }
    
    func handleCancelEditMessageButtonTap() {
        resetEditingState()
    }
    
    func updateEditingMessage() {
        guard let editing = editingMessage,
              let index = messages.firstIndex(where: { $0.id == editing.id })
        else { return }
        messages[index].comment = inputMessageText
        messages[index].speaker = selectedSpeaker
        resetEditingState()
    }
    
    private func resetEditingState() {
        editingMessage = nil
        inputMessageText = ""
    }
}
