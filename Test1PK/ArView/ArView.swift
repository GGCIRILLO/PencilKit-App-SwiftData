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
        // to store image in url
        if(ArImage != nil) {
            print("[ArViewContainer] in container ")
            let arView = ARView(frame: .zero)
            let anchor = AnchorEntity()
            
            // Create materials for the box and cornice
            var materialCornice = SimpleMaterial()
            var material = SimpleMaterial()
            
            // Load the image data and create a CGImage from it
            
            let ImageActualData = try! PKDrawing(data: ArImage!).image(from: PKDrawing(data: ArImage!).bounds, scale: 1.0).cgImage
            
            
            // Set the textures for the cornice and box materials
            materialCornice.color = .init(tint: .white.withAlphaComponent(0.999),
                                          texture: try! MaterialParameters.Texture(TextureResource.load(named: "Cornice")))
            material.color = .init(tint: .white.withAlphaComponent(0.999),
                                   texture: try! MaterialParameters.Texture(TextureResource.generate(from: ImageActualData!, options: .init(semantic: .hdrColor))))
            
            // Create the box and cornice models
            let box = ModelEntity(
                mesh: MeshResource.generateBox(width: 2.0, height: 2.0, depth: 0.01),
                materials: [ material]
            )
            let boxCornice = ModelEntity(
                mesh: MeshResource.generateBox(width: 2.2, height: 2.2, depth: 0.1),
                materials: [materialCornice]
            )
            
            //wall anchor test
            let anchorWall = AnchorEntity(.plane([.vertical],
                                             classification: [.wall],
                                                 minimumBounds: [0.6, 0.6]))
            let planceMesh = MeshResource.generatePlane(width: 2.5, depth: 2.5, cornerRadius: 0.1)
            
            let WallCornice = ModelEntity(mesh: planceMesh, materials: [material])
            anchorWall.addChild(WallCornice)
            anchorWall.addChild(boxCornice)
            anchorWall.addChild(box)

 
            // Create an anchor for the camera and attach the box and cornice to it
             let cameraAnchor = AnchorEntity(.camera)
             cameraAnchor.addChild(box)
             cameraAnchor.addChild(boxCornice)
 
            // Add the camera anchor and image anchor to the ARView scene
            arView.scene.addAnchor(cameraAnchor)
            arView.scene.addAnchor(anchor)
            arView.scene.addAnchor(anchorWall)

            // Set the translation of the box to -4 meters in the z-axis
            box.transform.translation = [0, 0, -3.9]
            boxCornice.transform.translation = [0, 0, -4]
            
            // check for plane anchor
                
          
            print(arView.scene.anchors.count)
            
            return arView
        }
        return ARView()
    }
        func updateUIView(_ uiView: ARView, context: Context) {}
    
}

/*#Preview {
    ArView()
}
 */
