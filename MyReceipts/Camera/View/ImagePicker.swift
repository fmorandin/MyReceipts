//
//  ImagePicker.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.cameraDevice = .rear
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {

        Coordinator(self)
    }
}
