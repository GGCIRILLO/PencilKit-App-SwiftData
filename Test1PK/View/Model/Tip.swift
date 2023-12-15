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
        Text("Share")
    }
    var message: Text? {
        Text("Press the note for a while to share")
    }
    
    var image: Image? {
        Image(systemName: "square.and.arrow.up")
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
