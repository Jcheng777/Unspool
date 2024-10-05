//
//  JournalEntry.swift
//  Unwind
//
//  Created by Jesse Cheng on 10/5/24.
//

import Foundation

import SwiftUI

struct JournalEntry: Identifiable {
    var id = UUID()
    var date: String
    var content: String
}
