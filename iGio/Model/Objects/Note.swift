//
//  Nota.swift
//  SFA
//
//  Created by Dani Tox on 09/03/19.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import Foundation
import RealmSwift

class Note : Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var title = ""
    @objc dynamic var body : Data?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func setBody(attributedString: NSAttributedString) {
        let docAttrs = [NSAttributedString.DocumentAttributeKey.documentType : NSAttributedString.DocumentType.rtf]
        let data = try? attributedString.data(from: .init(location: 0, length: attributedString.length), documentAttributes: docAttrs)
        self.body = data
    }
    
    func getBody() -> NSAttributedString {
        if let bodyData = self.body, let attributedString = try? NSAttributedString(data: bodyData, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil) {
            return attributedString
        } else {
            return NSAttributedString(string: "")
        }
    }
}

class NoteStorage: Equatable {
    static func == (lhs: NoteStorage, rhs: NoteStorage) -> Bool {
        return lhs.date == rhs.date
    }
    
    var date: Date
    var notes: [Note]
    
    init(date: Date, notes: [Note]) {
        self.date = date
        self.notes = notes
    }
}
