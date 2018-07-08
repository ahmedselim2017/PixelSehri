//
//  ViewController.swift
//  PixelSehri
//
//  Created by Ahmed Selim Üzüm on 6.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HaritaVC: UIViewController {

    @IBOutlet weak var haritaGoruntuleyicisi: MKMapView!
    var lokasyonDuzenleyicisi=CLLocationManager();
    let yetkiDurumu=CLLocationManager.authorizationStatus();
    let bolgeRadyus:Double=1000;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lokacsyonServisleriAyarla();
        lokasyonDuzenleyicisi.delegate=self;
        haritaGoruntuleyicisi.delegate=self;
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func haritayiOrtalaBasildi(_ sender: Any) {
        if yetkiDurumu == .authorizedAlways || yetkiDurumu == .authorizedWhenInUse{
            haritayiLokasyonaGoreAyarla();
        }
    }
    
}

extension HaritaVC: MKMapViewDelegate{
    func haritayiLokasyonaGoreAyarla(){
        guard let koordinat=lokasyonDuzenleyicisi.location?.coordinate else{return;}
        let koordinatBolgesi=MKCoordinateRegion(center: koordinat, latitudinalMeters: bolgeRadyus*2, longitudinalMeters: bolgeRadyus*2)
        haritaGoruntuleyicisi.setRegion(koordinatBolgesi, animated: true);
    }
}

extension HaritaVC: CLLocationManagerDelegate{
    
    func lokacsyonServisleriAyarla(){
        if yetkiDurumu == .notDetermined{
            lokasyonDuzenleyicisi.requestAlwaysAuthorization();
        }
        else{
            return;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        haritayiLokasyonaGoreAyarla();
    }
    
}
