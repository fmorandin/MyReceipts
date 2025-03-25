//
//  ReceiptView.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 20/03/2025.
//

import SwiftUI
import CoreData

struct ReceiptView: View {

    @StateObject private var viewModel = ReceiptListViewModel()
    @State private var isRecognizingText = false

    var body: some View {
        NavigationView {
            VStack {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.receipts) { receipt in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Location: \(receipt.location ?? "Unknown")")
                                Text("Value: \(receipt.totalAmount ?? "Unknown")")
                                Text("Date: \(receipt.timestamp ?? "Unknown")")
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: { viewModel.showScanner = true }) {
                        Label("Add Item", systemImage: "camera")
                    }
                }
            }
            .onAppear {
                viewModel.fetchReceipts()
            }
            .sheet(
                isPresented: $viewModel.showScanner,
                content: {
                    ScannerView { result in

                        switch result {
                        case .success(let scannedImages):

                            isRecognizingText = true

                            TextRecognition(scannedImages: scannedImages) { result in

                                switch result {
                                case .success(let items):
                                    viewModel.parseAndAddReceipt(items)
                                case .failure(let error):
                                    viewModel.errorMessage = error.localizedDescription
                                }

                                isRecognizingText = false
                            }
                            .recognizeText()

                        case .failure(let error):
                            viewModel.errorMessage = error.localizedDescription
                        }

                        viewModel.showScanner = false

                    } didCancelScanning: {
                        viewModel.showScanner = false
                    }
                })
        }
    }
}

#Preview {
    ReceiptView()
}
