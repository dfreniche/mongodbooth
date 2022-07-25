//
//  QRCodeReaderViewController.swift
//  MongoDbooth
//
//  Created by Diego Freniche Brito on 19/7/22.
//

import UIKit
import AVFoundation
import CoreLocation
import CoreLocation

final class QRCodeReaderViewController: UIViewController {
    // closure called when a QR is read
    public var onQRCodeRead: ((String, [CLLocation]?) -> Void)?
    
    private let captureSession = AVCaptureSession()
    lazy private var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    private var qrCodeFrameView: UIView?
    
    private let manager = CLLocationManager()
    private var locations: [CLLocation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let metadataOutput = AVCaptureMetadataOutput()

        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice),
              captureSession.canAddOutput(metadataOutput),
              captureSession.canAddInput(input) else { return }

        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 6
            let captureRectMargin = 20.0
            let captureRectWidth = view.frame.size.width - captureRectMargin*2
            let captureRectYPosition = (view.frame.size.height / 2.0) - captureRectWidth
            qrCodeFrameView.frame = CGRect(origin: CGPoint(x: captureRectMargin, y: captureRectYPosition), size: CGSize(width: captureRectWidth, height: captureRectWidth))
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        captureSession.addInput(input)
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.qr]
        captureSession.startRunning()
        
        initCoreLocationUpdates()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
    }
}

// MARK: - AVFoundation
extension QRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let contentString = readableObject.stringValue else {
            print("❌ QR Code can't be read!")
            return
        }
        
        if readableObject.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = previewLayer.transformedMetadataObject(for: readableObject)
//            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            qrCodeFrameView?.layer.borderColor = UIColor.red.cgColor
            qrCodeFrameView?.layer.borderWidth = 10
        }
        
        // haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        captureSession.stopRunning()

        // return QR code via closure
        onQRCodeRead?(contentString, locations)
    }
}

// MARK: - CoreLocation
extension QRCodeReaderViewController: CLLocationManagerDelegate {
    func initCoreLocationUpdates() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations = locations
    }
}
