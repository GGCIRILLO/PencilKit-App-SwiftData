//
//  NoteViewController.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 11/12/23.
//

import SwiftUI
import PencilKit

class NoteViewController: UIViewController {
    
    // Lazily initialize the PencilKit canvas view with specific configurations.
    lazy var canvas: PKCanvasView = {
        let view = PKCanvasView()
        view.drawingPolicy = .anyInput
        //test zooming
       view.minimumZoomScale = 0.2
       view.maximumZoomScale = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Lazily initialize the PencilKit tool picker and add the view controller as an observer.
    lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(self)
        return toolPicker
    }()
    
    // Data representation of the drawing, initially set to an empty Data object.
    var noteData = Data()
    
    // Closure to notify when the drawing changes (The idea is that an external entity can provide a closure to be executed when the drawing on the canvas changes)
    var noteChanged: (Data) -> Void = {_ in}
    
    // This method is called when the view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the PencilKit canvas view as a subview to the main view.
        view.addSubview(canvas)
        
        // Set up auto-layout constraints for the canvas to fill the entire view.
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Make the tool picker visible for the canvas and add it as an observer.
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        
        // Set the delegate of the canvas to this view controller.
        canvas.delegate = self
        
        // Make the canvas the first responder, enabling user interactions.
        canvas.becomeFirstResponder()
        
        // If there is existing drawing data, attempt to initialize the canvas with it.
        if let note = try? PKDrawing(data: noteData) {
            canvas.drawing = note
        }
    }
}

extension NoteViewController : PKToolPickerObserver, PKCanvasViewDelegate {
    
    // This method is called when the drawing on the canvas changes.
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        // Notify the external closure about the change by passing the updated drawing data.
        noteChanged(canvasView.drawing.dataRepresentation())
    }
}
