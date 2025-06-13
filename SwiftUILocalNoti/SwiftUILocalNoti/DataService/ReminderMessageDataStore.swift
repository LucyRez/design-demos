//
//  MessageDataStore.swift
//  SwiftUILocalNoti
//
import Foundation

typealias DS = ReminderMessageDataStore

struct ReminderMessageDataStore
{
    static let shared = ReminderMessageDataStore()
    private let key = "su.brf.eventMessage"
    
    func save(_ message: ReminderMessage){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(message) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func load() -> ReminderMessage {
        if let savedMessage = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedMessage = try? decoder.decode(ReminderMessage.self, from: savedMessage) {
                return loadedMessage
            }
        }
        return ReminderMessage()
    }
}
