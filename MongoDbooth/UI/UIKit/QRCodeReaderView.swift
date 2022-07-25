//
//  QRCodeReaderView.swift
//  MongoDbooth
//
//  Created by Diego Freniche Brito on 19/7/22.
//

import SwiftUI
import UIKit
import CoreLocation

struct QRCodeReaderView: UIViewControllerRepresentable {
    
    public var onQRCodeRead: ((String, [CLLocation]?) -> Void)

    func makeUIViewController(context: Context) -> QRCodeReaderViewController {
        let controller = QRCodeReaderViewController()
        
        controller.onQRCodeRead = onQRCodeRead
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QRCodeReaderViewController, context: Context) {
        
    }
}
