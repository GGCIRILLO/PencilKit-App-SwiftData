//
//  AddNewNoteView.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 11/12/23.
//

import SwiftUI

// AddNewCanvasView is the view for creating a new canvas.
// Users can input a title, and it is saved using CoreData.
struct AddNewNoteView: View {
    // Managed object context for SwiftData operations.
    @Environment(\.modelContext) private var modelContext
    
    // Presentation mode to dismiss the view.
    @Environment(\.dismiss) private var dismiss
    
    // State for storing the canvas title.
    @State private var noteTitle = ""
    
    @State private var noteTag = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Text field for entering the canvas title.
                    TextField("Note title", text: $noteTitle)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(Text("Craft a new note"))
            .navigationBarItems(
                leading: Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                }),
                trailing: Button(action: {
                    // Check if the canvas title is not empty.
                    if !noteTitle.isEmpty {
                        // Create a new Drawing entity in the CoreData managed object context.
                        let note = Note()
                        
                        // Set the title and tag of the drawing to the entered canvas title.
                        note.title = noteTitle
                        note.tag = noteTag
                        modelContext.insert(note)
                        
                        do {
                            // Save the new drawing to the CoreData managed object context.
                            try modelContext.save()
                        } catch {
                            // Print an error message if there's an issue with saving.
                            print(error)
                        }
                        
                        // Dismiss the current view and return to the previous view.
                       dismiss()

                    }
                }, label: {
                    Text("Save")
                })
            )
        }
    }
}
#Preview {
    AddNewNoteView()
}
