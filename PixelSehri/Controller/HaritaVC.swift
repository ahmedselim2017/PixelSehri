//
//  ViewController.swift
//  PixelSehri
//
//  Created by Ahmed Selim Üzüm on 6.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class HaritaVC: UIViewController {

    @IBOutlet weak var haritaGoruntuleyicisi: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        haritaGoruntuleyicisi.delegate=self;
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func haritayiOrtalaBasildi(_ sender: Any) {
    }
    
}

extension HaritaVC: MKMapViewDelegate{
    
}
