//
//  DocumentCamera.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-01-22.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import SwiftUI
import VisionKit

/**
 This document camera wraps `VNDocumentCameraViewController`
 and can be used to scan documents with the device's camera.
 
 You create a camera instance by providing two action blocks
 that can be used to inspect what happens with the operation:
 
 ```swift
 let camera = DocumentCamera(
    cancelAction: { print("User did cancel") }  // Optional
    resultAction: { result in ... }             // Mandatory
 }
 ```
 
 The camera result is a `VNDocumentCameraScan` that contains
 a list of the scanned files, if any.
 
 You can use this view with `SheetContext` to easily present
 it as a modal sheet.
 */
@available(iOS 13, *)
public struct DocumentCamera: UIViewControllerRepresentable {
    
    public init(
        cancelAction: @escaping CancelAction = {},
        resultAction: @escaping ResultAction) {
        self.cancelAction = cancelAction
        self.resultAction = resultAction
    }
    
    public typealias CameraResult = Result<VNDocumentCameraScan, Error>
    public typealias CancelAction = () -> Void
    public typealias ResultAction = (CameraResult) -> Void
    
    private let cancelAction: CancelAction
    private let resultAction: ResultAction
        
    public func makeCoordinator() -> Coordinator {
        Coordinator(camera: self)
    }
    
    public func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
}

@available(iOS 13, *)
public extension DocumentCamera {
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        public init(camera: DocumentCamera) {
            self.camera = camera
        }
        
        private let camera: DocumentCamera
        
        public func documentCameraViewControllerDidCancel(
            _ controller: VNDocumentCameraViewController) {
            camera.cancelAction()
        }
        
        public func documentCameraViewController(
            _ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            camera.resultAction(.failure(error))
        }
        
        public func documentCameraViewController(
            _ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            camera.resultAction(.success(scan))
        }
    }
}
#endif
