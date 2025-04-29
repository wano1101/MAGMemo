//
//  MemoRepository.swift
//  MAGMemo
//
//  Created by RikutoSato on 2025/04/25.
//

import FirebaseFirestore
import FirebaseAuth

class MemoRepository {
    private let db = Firestore.firestore()

    func saveMAGMemo(_ item: MAGMemo) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "itemsRepository", code: 100, userInfo: [NSLocalizedDescriptionKey: "User ID not found."])
        }

        let messagesData = try JSONSerialization.jsonObject(with: JSONEncoder().encode(item.messages), options: []) as? [[String: Any]] ?? []

        let itemData: [String: Any] = [
            "id": item.id,
            "userId": item.userId,
            "memberName": item.memberName,
            "eventName": item.eventName,
            "eventDate": Timestamp(date: item.eventDate),
            "messages": messagesData
        ]

        try await db.collection("Users").document(userId).collection("MAGMemos").document(item.id).setData(itemData)
    }

    func deleteMAGMemo(_ id: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "itemsRepository", code: 101, userInfo: [NSLocalizedDescriptionKey: "User ID not found."])
        }
        try await db.collection("Users").document(userId).collection("MAGMemos").document(id).delete()
    }

    func fetchMAGMemos() async throws -> [MAGMemo] {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "itemsRepository", code: 102, userInfo: [NSLocalizedDescriptionKey: "User ID not found."])
        }
        let snapshot = try await db.collection("Users").document(userId).collection("MAGMemos").getDocuments()
        return try snapshot.documents.compactMap { doc in
            let data = doc.data()
            guard
                let id = data["id"] as? String,
                let userId = data["userId"] as? String,
                let memberName = data["memberName"] as? String,
                let eventName = data["eventName"] as? String,
                let eventTimestamp = data["eventDate"] as? Timestamp,
                let messagesArray = data["messages"] as? [[String: Any]]
            else {
                return nil
            }
            let messagesData = try JSONSerialization.data(withJSONObject: messagesArray)
            let messages = try JSONDecoder().decode([Message].self, from: messagesData)
            return MAGMemo(id: id, userId: userId, memberName: memberName, eventName: eventName, eventDate: eventTimestamp.dateValue(), messages: messages)
        }
    }

    func fetchMAGMemo(by id: String) async throws -> MAGMemo? {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "itemsRepository", code: 103, userInfo: [NSLocalizedDescriptionKey: "User ID not found."])
        }
        let doc = try await db.collection("Users").document(userId).collection("MAGMemos").document(id).getDocument()
        guard let data = doc.data() else { return nil }

        guard
            let id = data["id"] as? String,
            let userId = data["userId"] as? String,
            let memberName = data["memberName"] as? String,
            let eventName = data["eventName"] as? String,
            let eventTimestamp = data["eventDate"] as? Timestamp,
            let messagesArray = data["messages"] as? [[String: Any]]
        else {
            return nil
        }
        let messagesData = try JSONSerialization.data(withJSONObject: messagesArray)
        let messages = try JSONDecoder().decode([Message].self, from: messagesData)
        return MAGMemo(id: id, userId: userId, memberName: memberName, eventName: eventName, eventDate: eventTimestamp.dateValue(), messages: messages)
    }
}
