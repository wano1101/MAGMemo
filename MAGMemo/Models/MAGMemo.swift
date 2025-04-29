//
//  MAGMemo.swift
//  MAGMemo
//
//  Created by 粟野颯太 on 2025/03/23.
//

import Foundation

struct MAGMemo: Identifiable, Codable {
    let id: String
    let userId: String
    var memberName: String
    var eventName: String
    var eventDate: Date
    var messages: [Message]
}
