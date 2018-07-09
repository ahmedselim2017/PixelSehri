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

    @IBOutlet weak var ViewFotoğraflar: UIView!

    @IBOutlet weak var haritaGoruntuleyicisi: MKMapView!
    @IBOutlet weak var btnOrtalaGizli: UIButton!
    @IBOutlet weak var btnOrtala: UIView!
    var lokasyonDuzenleyicisi=CLLocationManager();
    let yetkiDurumu=CLLocationManager.authorizationStatus();
    let bolgeRadyus:Double=1000;
    
    var ekranBoyutu=UIScreen.main.bounds;
    var bekletici:UIActivityIndicatorView?;
    var lblBeklemeSeviyesi:UILabel?;
    
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
    
    func fotografViewAnimasyonu(){
        self.ViewFotoğraflar.alpha=0;
        self.btnOrtalaGizli.alpha=0;
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.btnOrtalaGizli.isHidden=false;
            self.btnOrtalaGizli.alpha=1;
            self.ViewFotoğraflar.isHidden = false;
            self.ViewFotoğraflar.alpha=1;
        }, completion: { _ in
            
        })
        self.loadViewIfNeeded();
    }
    
    func fotografViewGeriAnimasyonu(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.ViewFotoğraflar.alpha = 0
            self.btnOrtalaGizli.alpha=0;
        }, completion: { _ in
            self.btnOrtalaGizli.isHidden=true;
            self.ViewFotoğraflar.isHidden = true
        })
        self.loadViewIfNeeded();
    }
    
    @objc func deneme(sender:UISwipeGestureRecognizer){
        fotografViewGeriAnimasyonu();
    }
    
    func bekleticiEkle(){
        bekletici=UIActivityIndicatorView();
        bekletici?.center=CGPoint(x: (ekranBoyutu.width/2)-((bekletici?.frame.width)!/2), y:150);
        bekletici?.activityIndicatorViewStyle = .whiteLarge;
        bekletici?.color=#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        bekletici?.startAnimating();
        ViewFotoğraflar.addSubview(bekletici!);
    }
    
    @IBAction func haritayiOrtalaBasildi(_ sender: Any) {
        if yetkiDurumu == .authorizedAlways || yetkiDurumu == .authorizedWhenInUse{
            haritayiLokasyonaGoreAyarla();
        }
    }
    
    @objc func fotografViewGeriyeAnimasyon(){
        let geri=UISwipeGestureRecognizer(target: self, action: #selector(deneme(sender:)));
        geri.direction = .down;
        ViewFotoğraflar.addGestureRecognizer(geri);
        
        
    }
    
}

extension HaritaVC: MKMapViewDelegate{
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }
        let pinAnnotatin=MKPinAnnotationView(annotation: annotation, reuseIdentifier: "haritaPini");
        pinAnnotatin.pinTintColor=#colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1);
        pinAnnotatin.animatesDrop=true;
        return pinAnnotatin;
    }
    
    @objc func pinBirak(sender:UITapGestureRecognizer){
        pinleriKalidr();
        fotografViewAnimasyonu();
        bekleticiEkle();
        fotografViewGeriyeAnimasyon();
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
