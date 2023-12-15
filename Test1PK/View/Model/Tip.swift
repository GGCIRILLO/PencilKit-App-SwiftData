//
//  Tip.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 13/12/23.
//

import Foundation
import TipKit

struct CraftNewNote : Tip {
    var title: Text{
        Text("Craft a new note")
    }
    
    var message: Text? {
        Text("Tap on the button to craft a new note")
    }
    
    var image: Image? {
        Image(systemName: "scribble.variable")
    }
}

struct shareNote : Tip {
    var title: Text{
        Text("Features")
    }
    var message: Text? {
        Text("Press the note for a while to discover amazing features...")
    }
    
    var image: Image? {
        Image(systemName: "wand.and.stars.inverse")
    }
}

struct startTimer : Tip {
    var title: Text{
        Text("Timer")
    }
    

    var message: Text?{
        Text("Press the buttons for a while to select the timer")
            .fontWeight(.regular)
            .font(.callout)
    }
    
    var image: Image? {
        Image(systemName: "timer")
    }
}
