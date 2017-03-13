//
//  CameraVC.swift
//  custom-camera
//
//  Created by Mikael Teklehaimanot on 3/13/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    
    var captureDevice: AVCaptureDevice!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MIKAEL: view did appear....")
    }
    
    func setupCamera() {
        
        //capture session begins at photo screen (not video record)
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        //grab devices and assign to capture device variable
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices {
            captureDevice = availableDevices.first
            beginSession()
        }
        
    }
    
    func beginSession() {
        
        //get input from device and add to session
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print("MIKE: there was an error adding device input to session: \(error.localizedDescription)")
        }
        
        //begin layer setup use session to display camera input through layer
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
            
            
        }
        
    }

}
