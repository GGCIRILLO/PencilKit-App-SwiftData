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
    
    @Environment(\.scenePhase) var phase
    @Environment(\.modelContext) private var modelContext
    @Query private var notes : [Note]
    @State private var showNoteSheet = false
    
    let craftNewNote = CraftNewNote()
    let shareNoteTip = shareNote()
    
    @Environment(PomodoroModel.self) private var pomodoroModel
    @State private var showTimerSheet = false
    @State var lastActiveTimeStamp : Date = Date()

    
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
        .onChange(of: phase, { [self] oldValue, newValue in
            if pomodoroModel.isStarted{
                // Handling the scenario when the app transitions to the background
                if newValue == .background {
                    // Updating the last active timestamp to the current date
                    lastActiveTimeStamp = Date()
                }
                
                // Handling the scenario when the app transitions to the active state
                if newValue == .active {
                    
                    // Calculating the time difference since the app was last active
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    
                    // Checking if the remaining time in the Pomodoro timer is less than or equal to 0
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        
                        // If the remaining time is zero or negative, marking the Pomodoro as finished
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                        
                    } else {
                        
                        // If there is still time remaining, subtracting the time difference from the total seconds
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        })
    
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

 
