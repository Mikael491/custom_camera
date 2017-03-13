//
//  ViewController.swift
//  custom-camera
//
//  Created by Mikael Teklehaimanot on 3/13/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {
    
    var photo : UIImage?
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo {
            photoImageView.image = photo
        }
        
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

