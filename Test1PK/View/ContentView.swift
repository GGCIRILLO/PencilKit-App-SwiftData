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
    @State private var showNoteSheet = false
    
    let craftNewNote = CraftNewNote()
    let shareNoteTip = shareNote()
    
    @Environment(PomodoroModel.self) private var pomodoroModel
    @State private var showTimerSheet = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                // List of drawings with navigation links to DrawingView(open the drawing)
                
                ScrollView{
                    if !notes.isEmpty{
                        TipView(shareNoteTip)
                            .frame(height: 40)
                            .padding()
                    }
                    ForEach(notes) { note in
                        NavigationLink(destination: NoteView(id: note.id, data: note.image, title: note.title)){
                            NoteListView(note: note)
                        }
//                        .onDelete(perform: deleteItems)
                    }
                    .padding()
                    
                    
                }
                
                .navigationTitle("Notes")
                .toolbar {
                    //Button to show the sheet for starting the timer
                    Button {
                        showTimerSheet.toggle()
                    } label: {
                        Image(systemName: "gauge.with.needle")
                    }
                    
                    // Button to show the sheet for adding a new canvas
                    Button(action: {
                        showNoteSheet.toggle()
                        craftNewNote.invalidate(reason: .actionPerformed)
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .popoverTip(craftNewNote)
                    })
                }
                Spacer()
                
                    .sheet(isPresented: $showNoteSheet, content: {
                        AddNewNoteView()
                    })
                    .sheet(isPresented: $showTimerSheet) {
                        TimerView()
                            .environment(pomodoroModel)
                    }
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            
            // Placeholder for when no canvas is selected.
            VStack {
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("No canvas selected")
                    .font(.title)
            }
        }
    
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
            try? Tips.configure([
                Tips.ConfigurationOption
                .datastoreLocation(.applicationDefault)])
        }
        .environment(PomodoroModel())
        .modelContainer(for: Note.self, inMemory: true)
}

 
