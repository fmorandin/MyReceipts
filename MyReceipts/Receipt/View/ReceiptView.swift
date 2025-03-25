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

    var body: some View {
        NavigationView {
            VStack {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                } else {
                    List(viewModel.receipts) { receipt in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Location: \(receipt.location)")
                            Text("Value: \(receipt.totalAmount, specifier: "%.2f") - \(receipt.currency)")
                            Text("Date: \(receipt.timestamp, formatter: itemFormatter)")
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
            .sheet(isPresented: $viewModel.showScanner, content: {
                ScannerView { result in

                    switch result {
                    case .success(let scannedImages):
                        break
                        
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

private let itemFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ReceiptView()
}
