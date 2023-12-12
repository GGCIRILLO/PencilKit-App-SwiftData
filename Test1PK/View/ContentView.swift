//
//  ContentView.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 11/12/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var notes : [Note]
    
    @State private var showSheet = false

    var body: some View {
        NavigationView {
            VStack {
                // List of drawings with navigation links to DrawingView(open the drawing)
                List {
                    ForEach(notes) { note in
                        
                        NavigationLink(destination: NoteView(id: note.id, data: note.image, title: note.title)) {
                            
                            Text(note.title ?? "Untitled")
                            
                             
                        
                        }
                        
                    }
                    .onDelete(perform: deleteItems)
                    
                    //Horrible button to save shared data
                    Button("Save Imported Note"){
                        modelContext.insert(sharedNote)
                    }
                    // Button to show the sheet for adding a new canvas
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Canvas")
                        }
                        .foregroundStyle(.blue)
                    })
                    .sheet(isPresented: $showSheet, content: {
                        AddNewNoteView()
                    })
                }
                .navigationTitle("Drawings")
                .toolbar {
                    EditButton()
                }
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
        .modelContainer(for: Note.self, inMemory: true)
}
