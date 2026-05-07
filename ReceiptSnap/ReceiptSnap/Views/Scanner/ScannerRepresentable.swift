import SwiftUI
import VisionKit
import Vision

struct ScannerRepresentable: UIViewControllerRepresentable {
    var onScanComplete: (Receipt) -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: ScannerRepresentable

        init(_ parent: ScannerRepresentable) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let images = (0..<scan.pageCount).map { scan.imageOfPage(at: $0) }
            if let firstImage = images.first {
                OCRService.shared.recognizeText(from: firstImage) { result in
                    DispatchQueue.main.async {
                        let receipt = ReceiptParser.parse(from: result, image: firstImage)
                        self.parent.onScanComplete(receipt)
                    }
                }
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
        }
    }
}
