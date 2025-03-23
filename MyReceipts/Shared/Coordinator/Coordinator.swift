//
//  Coordinator.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import UIKit

final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var parent: ImagePicker

    init(_ parent: ImagePicker) {
        
        self.parent = parent
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            parent.selectedImage = image
        }

        parent.presentationMode.wrappedValue.dismiss()
    }
}
