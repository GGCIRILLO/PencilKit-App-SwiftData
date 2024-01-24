# Test1PK

**Overview:**
This drawing app is a creative tool designed for iOS, allowing users to express their ideas, sketches, and drawings digitally. Developed using Swift, UIKit, PencilKit, and SwiftData, the app provides a seamless and intuitive drawing experience.

**Key Frameworks:**
1. **SwiftData:**
   - Persistent data storage for user drawings.
   - Model includes `canvasData`, `title`, and `id`.

2. **PencilKit:**
   - Implements the drawing canvas for a natural drawing experience.
   - Supports Apple Pencil and touch input.

3. **Swift and UIKit:**
   - Developed using Swift, Apple's modern programming language.
   - Utilizes UIKit for creating the user interface.

**Key Functionalities:**
1. **Canvas Creation:**
   - Create a new canvas for fresh drawings.
   - Each canvas has a unique identifier (`UUID`).

2. **Canvas Selection:**
   - View and select existing canvases.
   - Navigate to drawings by tapping on canvas titles.

3. **Drawing Canvas:**
   - Powered by PencilKit for a lifelike drawing experience.
   - Supports drawing, sketching, and creative expression.

4. **Canvas Saving:**
   - Auto-save changes to SwiftData for persistent storage.
   - Updates `canvasData` attribute in the associated `Drawing` entity.

5. **Canvas Deletion:**
   - Delete canvases directly from the main view.
   - Removes corresponding `Drawing` entity from SwiftData.

6. **Adding New Canvases:**
   - Add new canvases via the "Add Canvas" button.
   - Input a title for the new canvas using AddNewCanvasView.

7. **User-Friendly Interface:**
   - Clean and accessible interface for users of all levels.
   - Navigation facilitated by SwiftUI's navigation views and UIKit components.

**Conclusion:**
This drawing app combines the power of Swift, UIKit, PencilKit, and SwiftData to deliver a seamless and enjoyable digital drawing experience. Whether users are sketching ideas, creating art, or jotting down notes, this app provides a versatile platform for unleashing creativity on iOS devices.

Happy drawing!

#Switch from CoreData to SwiftData
As you may know, I have a very similar repository in my account. There are few differences and one of them is the framework used to store data.
The transition is not easy, especially when you have to save every minimum change and autosave it, but I did it. 
First advise is understanding in deep the needs of your code and then try to achieve the solution step by step. Secondly, you can find online the sintax differences between the two frameworks.
It's easy to create the model, insert it in the model context in th enviroment and save or delete it. Look at the [documentation](https://developer.apple.com/documentation/swiftdata) here.
By the way the most interesting part of this project was autosaving every change. It was done in the NoteRepresentableView in the `makeUIViewController` function.
First of all we create an istance of the `DrawingCanvasViewController` and set the initial drawing data. 
```swift
func makeUIViewController(context: Context) -> NoteViewController {
  let viewController = NoteViewController()
  viewController.noteData = data
```
Now we use closures to update the drawing. In these ones will be performed the magic. First create a Predicate to fetch the correct note in the model context by ID.
Then create an array of results and take the first one, the one that will correspond to the selected one, and assign the `updatedData` to his data.
```swift
viewController.noteChanged = { updatedData in
            
            // Update SwiftData with the latest drawing data.
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
```
The corresponding code in CoreData is: 
```swift
func makeUIViewController(context: Context) -> DrawingCanvasViewController {
   // Create a new instance of DrawingCanvasViewController.
        let viewController = DrawingCanvasViewController()
        
        // Set the initial drawing data and the closure to handle drawing changes.
        viewController.drawingData = data
        
        // Closure to handle drawing changes. Updates the corresponding CoreData entity.
        viewController.drawingChanged = { updatedData in
            // Update CoreData with the latest drawing data.
            let request: NSFetchRequest<Drawing> = Drawing.fetchRequest()
            
            // Create a predicate to find the Drawing entity with the specified ID. The %@ in the format string is a placeholder that gets replaced with the actual value (id in this case).
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            
            do {
                // Fetch the corresponding Drawing entity from CoreData.
                let result = try viewContext.fetch(request)
                
                // Update the canvasData attribute of the Drawing entity with the new data.
                let obj = result.first
                obj?.setValue(updatedData, forKey: "canvasData")
                
                do {
                    // Save the changes to CoreData.
                    try viewContext.save()
                } catch {
                    // Print an error message if there's an issue with saving.
                    print("Error saving CoreData changes:", error)
                }
            } catch {
                // Print an error message if there's an issue with fetching the entity.
                print("Error fetching CoreData entity:", error)
            }
        }
        
        // Return the configured UIKit view controller.
        return viewController
    }
```
Hope to be useful to someone that wants to improve his code and implement SwiftData over CoreData.
