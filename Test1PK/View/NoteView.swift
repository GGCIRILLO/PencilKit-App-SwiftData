//
//  NoteView.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 11/12/23.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.modelContext) private var context
    @State var id:UUID?
    @State var data:Data?
    @State var title:String?
    
    var body: some View {
        NoteRepresentableView(data: data ?? Data(), id: id ?? UUID())
    }
}

#Preview {
    NoteView()
}
