//
//  NoteModel.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 11/12/23.
//

import Foundation
import SwiftData

@Model class Note {
    var title: String?
    var id: UUID = UUID()
    var noteData: Data?
    

    init(title: String? = nil, canvasData: Data? = nil) {
        self.title = title
        self.noteData = canvasData
    }
    
}
