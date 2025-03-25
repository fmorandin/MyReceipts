//
//  ScannerView.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 25/03/2025.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {

    var didFinishScanning: ((_ result: Result<[UIImage], Error>) -> Void)
    var didCancelScanning: () -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {

        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator

        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {

        Coordinator(self)
    }
}
