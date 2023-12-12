//
//  Test1PKApp.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 11/12/23.
//

import SwiftUI
import SwiftData
//global variable to handle shared Data
// var sharedNote = Note(timestamp: Date.now, image: Data(), tag: "", title: "")

//test
 


@main
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        window.rootViewController = UIHostingController(rootView: ContentView().modelContainer(sharedModelContainer))
        window.makeKeyAndVisible()
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        do {
            print("I'm in \n")
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let importedNote = try decoder.decode(Note.self, from: data)
            print(importedNote.title ??  "test")
            
            
            let newItem = Note(timestamp: importedNote.timestamp!, image: importedNote.image!, tag: importedNote.tag ?? "Missing tag", title: importedNote.title ?? "Untitled")
            sharedModelContainer.mainContext.insert(newItem)
 
            
         } catch {
            print("Unable to load data: \(error)")
        }
        
        return true
    }
    

    
}




 
struct Test1PKApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
