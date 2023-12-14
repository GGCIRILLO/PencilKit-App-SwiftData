import SwiftUI
import Foundation

struct NoteListView: View {
    init(note: Note) {
            self.note = note
         }
    let note: Note
    @State private var showArView = false
    @State   var  ArImageData: Data = Data()

    var body: some View {
        NavigationLink(destination: NoteView(id: note.id, data: note.image, title: note.title)) {
            Text(note.title ?? "Untitled")
                .contextMenu {
                    ShareLink(
                                          item: note,
                                          preview: SharePreview(note.title ?? "Untitled", image: Image(uiImage: UIImage(data: note.image ?? Data()) ?? UIImage())))
                    
                    Button(action: {
                                             self.showArView = true
                                            ArImageData = note.image!
                        print("[NoteList] ArImageData :" + self.ArImageData.description)
                                         }, label: {
                                             HStack {
                                                 Text("Ar Mode")
                                                 Image(systemName: "pencil")
                                             }
                                         })
                }
            
                .sheet(isPresented:  $showArView) {
                    ARViewContainer(arImage: note.image!)
                }
        }
    }
}

 

 
