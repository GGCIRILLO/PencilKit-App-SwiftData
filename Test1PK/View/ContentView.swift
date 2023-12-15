//
//  ContentView.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 11/12/23.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var notes : [Note]
     @State private var showSheet = false
    
    let craftNewNote = CraftNewNote()
    let shareNoteTip = shareNote()
    
    var body: some View {
        NavigationView {
            
            VStack {
                // List of drawings with navigation links to DrawingView(open the drawing)
                
                Form {
                    if !notes.isEmpty{
                        TipView(shareNoteTip)
                            .frame(height: 40)
                    }
                    
                    Section{
                        
                        ForEach(notes) { note in
                            NoteListView(note: note)
                               
                        }.onDelete(perform: deleteItems)
                    }
                }
                .navigationTitle("Notes")
                .toolbar {
                    // Button to show the sheet for adding a new canvas
                    Button(action: {
                        showSheet.toggle()
                        craftNewNote.invalidate(reason: .actionPerformed)
                    }, label: {
                        HStack {
                            Image(systemName: "square.and.pencil")
                        }
                        .foregroundStyle(.blue)
                        
                            .popoverTip(craftNewNote)
                    })
                }
                Spacer()
            
                .sheet(isPresented: $showSheet, content: {
                    AddNewNoteView()
                })
            }
            
            // Placeholder for when no canvas is selected.
            VStack {
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("No canvas selected")
                    .font(.title)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .task {
//            try? Tips.resetDatastore()
            try? Tips.configure([
                Tips.ConfigurationOption
                .datastoreLocation(.applicationDefault)])
        }
        .modelContainer(for: Note.self, inMemory: true)
}

 
