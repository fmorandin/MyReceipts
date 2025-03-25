//
//  TextRecognition.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 25/03/2025.
//

import SwiftUI
import Vision

struct TextRecognition {

    var scannedImages: [UIImage]
    var didFinishRecognition: ((_ result: Result<[TextItem], Error>) -> Void)

    private func getTextRecognitionRequest(with textItem: TextItem) -> VNRecognizeTextRequest {

        let request = VNRecognizeTextRequest { request, error in

            // TODO: Proper error handling
            if let error = error {
                print("Error recognizing text: \(error)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }

                textItem.text += recognizedText.string
                textItem.text += "\n"
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        return request
    }

    func recognizeText() {

        var items = [TextItem]()

        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)

        queue.async {

            for image in scannedImages {

                guard let cgImage = image.cgImage else { return }

                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

                do {

                    let textItem = TextItem()

                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])

                    DispatchQueue.main.async {
                        items.append(textItem)
                    }

                } catch {
                    didFinishRecognition(.failure(error))
                }
            }

            DispatchQueue.main.async {
                didFinishRecognition(.success(items))
            }
        }
    }
}
