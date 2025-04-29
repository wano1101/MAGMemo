//
//  Message.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/23.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: UUID
    var speaker: Speaker
    var comment: String
}

enum Speaker: String, CaseIterable, Identifiable, Codable {
    case member = "相手"
    case myself = "あなた"
    
    var id: String { self.rawValue }
}
