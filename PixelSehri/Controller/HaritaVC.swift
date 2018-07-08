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

class HaritaVC: UIViewController ,UIGestureRecognizerDelegate{

    @IBOutlet weak var haritaGoruntuleyicisi: MKMapView!
    var lokasyonDuzenleyicisi=CLLocationManager();
    let yetkiDurumu=CLLocationManager.authorizationStatus();
    let bolgeRadyus:Double=1000;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lokacsyonServisleriAyarla();
        lokasyonDuzenleyicisi.delegate=self;
        haritaGoruntuleyicisi.delegate=self;
        ciftTiklamaEkle();
        // Do any additional setup after loading the view, typically from a nib.
    }

    func ciftTiklamaEkle(){
        let ciftTiklama=UITapGestureRecognizer(target: self, action: #selector(pinBirak(sender:)));
        ciftTiklama.numberOfTapsRequired=2;
        ciftTiklama.delegate=self;
        haritaGoruntuleyicisi.addGestureRecognizer(ciftTiklama);
    }
    
    
    
    
    @IBAction func haritayiOrtalaBasildi(_ sender: Any) {
        if yetkiDurumu == .authorizedAlways || yetkiDurumu == .authorizedWhenInUse{
            haritayiLokasyonaGoreAyarla();
        }
    }
    
}

extension HaritaVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }
        var pinAnnotatin=MKPinAnnotationView(annotation: annotation, reuseIdentifier: "haritaPini");
        pinAnnotatin.pinTintColor=#colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1);
        pinAnnotatin.animatesDrop=true;
        return pinAnnotatin;
    }
    
    @objc func pinBirak(sender:UITapGestureRecognizer){
        pinleriKalidr();
        let dokunulanNokta=sender.location(in: haritaGoruntuleyicisi);
        let dokunulanKoordinat=haritaGoruntuleyicisi.convert(dokunulanNokta, toCoordinateFrom: haritaGoruntuleyicisi);
        
        let annotation=HaritaPini(coordinate: dokunulanKoordinat, identifier: "haritaPini");
        haritaGoruntuleyicisi.addAnnotation(annotation);
        
        let koordinatBolgesi=MKCoordinateRegion(center: dokunulanKoordinat, latitudinalMeters: bolgeRadyus*2, longitudinalMeters: bolgeRadyus*2);
        
        haritaGoruntuleyicisi.setRegion(koordinatBolgesi, animated: true);
        
        print(dokunulanNokta);
    }
    
    func pinleriKalidr(){
        for annotation in haritaGoruntuleyicisi.annotations{
            haritaGoruntuleyicisi.removeAnnotation(annotation);
        }
    }
    
    func haritayiLokasyonaGoreAyarla(){
        guard let koordinat=lokasyonDuzenleyicisi.location?.coordinate else{return;}
        let koordinatBolgesi=MKCoordinateRegion(center: koordinat, latitudinalMeters: bolgeRadyus*2, longitudinalMeters: bolgeRadyus*2);
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
