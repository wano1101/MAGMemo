//
//  EditBasicInfoViewModel.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/26.
//

import SwiftUI

class EditBasicInfoViewModel: ObservableObject {
    
    @Published var magMemo: MAGMemo = MAGMemo(
        id: UUID().uuidString,
        userId: UserDefaults.standard.string(forKey: "anonymousUserUID") ?? "",
        memberName: "",
        eventName: "",
        eventDate: Date(),
        messages: []
    )
    
    init(magMemo: MAGMemo? = nil) {
        if let magMemo {
            self.magMemo = magMemo
        }
    }
    
    var canProceedToNext: Bool {
        !magMemo.memberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
