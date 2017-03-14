//
//  CameraVC.swift
//  custom-camera
//
//  Created by Mikael Teklehaimanot on 3/13/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    
    var captureDevice: AVCaptureDevice!
    
    var takePhoto = false
    
    override func viewWillAppear(_ animated: Bool) {
        setupCamera()
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
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value: kCVPixelFormatType_32BGRA)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "com.mikaelTeklehaimanot.captureSessionQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        
    }
    
    @IBAction func takePhotoButtonTapped(sender: UIButton) {
        takePhoto = true
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if takePhoto {
            takePhoto = false
            if let image = self.getPhotoFromSampleBuffer(sampleBuffer) {
                DispatchQueue.main.async {
                    let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoVC
                    photoVC.photo = image
                    
                    self.present(photoVC, animated: true, completion: {
                        self.stopSession()
                    })
                }
            }
            
        }
    }
    
    func getPhotoFromSampleBuffer(_ buffer: CMSampleBuffer) -> UIImage? {
        
        if let imageBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvImageBuffer: imageBuffer)
            let ciContext = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(imageBuffer), height: CVPixelBufferGetHeight(imageBuffer))
            if let image = ciContext.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image)
            }
        }
        
        return nil
    }
    
    func stopSession() {
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
    }

}



































