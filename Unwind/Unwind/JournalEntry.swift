//
//  JournalEntry.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import Foundation

import SwiftUI

struct JournalEntry: Identifiable, Decodable {
    let id: String  // Assuming id is a String and not necessarily a UUID
    let title: String
    let content:String
    let date: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Attempt to decode "id", provide a new UUID if decoding fails
        self.id = (try? container.decode(String.self, forKey: .id)) ?? UUID().uuidString
        
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        self.date = try container.decode(String.self, forKey: .date)
    }
}
