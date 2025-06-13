import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackground()
        setupCamera()
    }
    
    private func setupCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showErrorAlert(message: "No camera available.")
            return
        }

        let session = AVCaptureSession()
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              session.canAddInput(videoInput) else {
            showErrorAlert(message: "Cannot access camera.")
            return
        }
        session.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showErrorAlert(message: "Cannot scan QR codes.")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = previewLayer {
            view.layer.insertSublayer(previewLayer, at: 0)
        }

        captureSession = session
        DispatchQueue.global(qos: .userInitiated).async {
               session.startRunning()
           }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadataObject.type == .qr,
              let code = metadataObject.stringValue else {
            return
        }
        
        captureSession?.stopRunning()
        showUserInformationView(code: code)
    }

    private func setupBackground() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [
//            UIColor.purple.cgColor,
//            UIColor.systemPurple.cgColor,
//            UIColor.white.cgColor
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        view.layer.insertSublayer(gradientLayer, at: 0)
        view.backgroundColor = .clear
    }
    
    private func setupUI() {
        
        navigationItem.title = "Scanner"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        let gallerybutton = UIBarButtonItem(
            image: UIImage(systemName: "photo"),
            style: .plain,
            target: self,
            action: #selector(selectFromGallery)
        )
        gallerybutton.tintColor = .white
        navigationItem.rightBarButtonItem = gallerybutton
        
        view.backgroundColor = .white
        
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Open Gallery
    @objc private func selectFromGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let qrCodeImage = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) { [weak self] in
                self?.decodeQRCode(from: qrCodeImage)
            }
        } else {
            picker.dismiss(animated: true)
        }
    }
    
    
    // MARK: - Decode QR Code
    private func decodeQRCode(from image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            showErrorAlert(message: "Invalid Image")
            return
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        let features = detector?.features(in: ciImage) as? [CIQRCodeFeature]
        let code = features?.first?.messageString
        
        if let code = code {
            showUserInformationView(code: code)
        } else {
            showErrorAlert(message: "No QR code found in the image.")
        }
    }
    
    // MARK: - Show Result
    private func showUserInformationView(code: String) {
        AuthService.shared.fetchQRCodeData(from: code) { result in
            switch result {
            case .success(let qrData):
            
                DispatchQueue.main.async {
                    let qrCodeView = QRCodeResultView(frame: UIScreen.main.bounds)
                    qrCodeView.setData(qrData)
                    self.view.addSubview(qrCodeView)
                }
                
            case .failure(let error):
                print("Error fetching QR code data: \(error)")
            }
        }
    }
    
    // MARK: - Error Alert
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
