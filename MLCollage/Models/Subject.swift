//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 11/8/24.
//

import UIKit
import GRDB

struct Subject {
    var id: String
    var label: String
    var images: [UIImage]
}

extension Subject {
    init(label: String, images: [UIImage] = []) {
        id = UUID().uuidString
        self.label = label
        self.images = images
    }
    
    public static func == (lhs: Subject, rhs: Subject) -> Bool {
        if lhs.id.map(\.asciiValue) != lhs.id.map(\.asciiValue) { return false}
        return true
    }
}

struct DBSubject: TableRecord, EncodableRecord, Encodable, MutablePersistableRecord {
    static let databaseTableName: String = "subject"
    var id: Int64?
    
    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
