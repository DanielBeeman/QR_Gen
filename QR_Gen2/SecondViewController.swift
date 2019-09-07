//
//  SecondViewController.swift
//  QR_Gen2
//
//  Created by Daniel Beeman on 7/31/19.
//  Copyright © 2019 Daniel Beeman. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    
    var myString2 = String()
    var img2 = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = myString2
        myImageView.image = img2
        
        
    }
    
    
    

}
