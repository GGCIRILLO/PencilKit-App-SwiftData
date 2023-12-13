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
        Text("Press the button for a while to share")
    }
    
    var image: Image? {
        Image(systemName: "square.and.arrow.up")
    }
}
