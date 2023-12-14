//
//  ArView.swift
//  Test1PK
//
//  Created by Renato Ferrara on 14/12/23.
//


import SwiftUI
import PencilKit
import RealityKit


struct ARViewContainer: UIViewRepresentable {
    var ArImage: Data?
    
    init(arImage: Data) {
            self.ArImage = arImage
        print("[ArViewContainer init] " + self.ArImage!.description)
         }
      func makeUIView(context: Context) -> ARView {
          //to store image in url
           
          print("[ArViewContainer]  in container ")
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity()
        
        var material = SimpleMaterial()
          
          print("ArImage bytes : " + ArImage!.description)
          let ImageActualData =  try! PKDrawing(data: ArImage!).image(from: PKDrawing(data: ArImage!).bounds, scale: 1.0).cgImage
       //   let image: CGImage = UIImage(data: ArImage!, scale: 1)!.cgImage!
          
          
          
          material.color = .init(tint: .white.withAlphaComponent(0.999),
                                 texture:  try! MaterialParameters.Texture(TextureResource.generate(from: ImageActualData!, options: .init(semantic: .hdrColor))) /* {
                              do {
                                  return try MaterialParameters.Texture(TextureResource.load(contentsOf: fileURL))
                              } catch {
                                  print("Error info: \(error)")
                                  return nil
                              }
          }() */)
                               
                    
          
        material.metallic = .float(1.0)
        material.roughness = .float(0.0)
        
        let imageEntity = ModelEntity(mesh: .generateBox(width: 2.0, height: 2.0, depth: 0.1), materials: [material])
        
        imageEntity.position.z -= 2
        imageEntity.position.x -= 1
        imageEntity.position.y -= 2
        imageEntity.setParent(anchor)
        arView.scene.addAnchor(anchor)
        
      
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

/*#Preview {
    ArView()
}
 */
