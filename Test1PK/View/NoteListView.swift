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
            ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 60)
                                            .shadow(radius: 2)
                                        HStack {
                                            Text(note.title ?? "Untitled")
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.black)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                        .padding()
                                    }
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

 

 
