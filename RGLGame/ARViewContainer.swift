import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var showWinMessage: Bool

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        var arView: ARView?
        var cubeEntity: ModelEntity?

        init(parent: ARViewContainer) {
            self.parent = parent
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard let arView = arView, let cubeEntity = cubeEntity else { return }

            let cameraTransform = frame.camera.transform
            let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
            let cubePosition = cubeEntity.position(relativeTo: nil)
            
            let distance = simd_distance(cameraPosition, cubePosition)
            
            if distance < 0.5 { // Adjust this value as needed
                DispatchQueue.main.async {
                    self.parent.showWinMessage = true
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator

        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.5, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.translation.y = 1.5
        model.transform.translation.z = -1
        context.coordinator.cubeEntity = model

        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
