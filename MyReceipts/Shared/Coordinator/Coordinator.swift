//
//  Coordinator.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import UIKit
import VisionKit

final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {

    var parent: ScannerView

    init(_ parent: ScannerView) {

        self.parent = parent
    }

    func documentCameraViewController(
        _ controller: VNDocumentCameraViewController,
        didFinishWith scan: VNDocumentCameraScan
    ) {

        var scannedPages = [UIImage]()

        for pageNumber in 0..<scan.pageCount {
            scannedPages.append(scan.imageOfPage(at: pageNumber))
        }

        parent.didFinishScanning(.success(scannedPages))
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: any Error) {

        parent.didFinishScanning(.failure(error))
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {

        parent.didCancelScanning()
    }
}
