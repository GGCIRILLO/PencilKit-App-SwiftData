//
//  NoteRepresentableView.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 11/12/23.
//

import SwiftUI
import PencilKit
import SwiftData


struct NoteRepresentableView : UIViewControllerRepresentable {
    @Environment(\.modelContext) private var modelContext
    
    // Data and ID for the drawing canvas.
    var data: Data
    var id: UUID
    
    // This method is called when the SwiftUI view needs to update the UIKit view controller.
    func updateUIViewController(_ uiViewController: NoteViewController, context: Context) {
        // Update the UIKit view controller's drawing data with the latest data.
        uiViewController.noteData = data
    }
    
    // Type alias to specify the type of the represented UIViewController.
    typealias UIViewControllerType = NoteViewController
    
    // This method is called when the SwiftUI view creates the UIKit view controller.
    func makeUIViewController(context: Context) -> NoteViewController {
        // Create a new instance of DrawingCanvasViewController.
        let viewController = NoteViewController()
        
        // Set the initial drawing data and the closure to handle drawing changes.
        viewController.noteData = data
        
        // Closure to handle drawing changes. Updates the corresponding CoreData entity.
        viewController.noteChanged = { updatedData in
            
            // Update CoreData with the latest drawing data.
            do {
                // Save the changes to SwiftData.
                let descriptor = FetchDescriptor<Note>(predicate: #Predicate { note in
                    note.id == id
                })

                let result = try modelContext.fetch(descriptor)
                let note = result.first
                note?.image = updatedData
                
                do {
                    // Save the changes to SwiftData.
                    try modelContext.save()
                } catch {
                    // Print an error message if there's an issue with saving.
                    print("Error saving SwiftData changes:", error)
                }
            } catch {
                // Print an error message if there's an issue with saving.
                print("Error saving SwiftData changes:", error)
            }
        }
        return viewController
    }
}
