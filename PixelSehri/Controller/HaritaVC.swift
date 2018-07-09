//
//  ViewController.swift
//  PixelSehri
//
//  Created by Ahmed Selim Üzüm on 6.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit;
import CoreLocation;
import MapKit;
import Alamofire;
import AlamofireImage;


class HaritaVC: UIViewController ,UIGestureRecognizerDelegate{

    @IBOutlet weak var ViewFotoğraflar: UIView!

    @IBOutlet weak var haritaGoruntuleyicisi: MKMapView!
    @IBOutlet weak var btnOrtalaGizli: UIButton!
    @IBOutlet weak var btnOrtala: UIView!
    var lokasyonDuzenleyicisi=CLLocationManager();
    let yetkiDurumu=CLLocationManager.authorizationStatus();
    let bolgeRadyus:Double=1000;
    
    var koleksiyonGoruntuleyicisi:UICollectionView?;
    var flowLayout=UICollectionViewFlowLayout();
    var ekranBoyutu=UIScreen.main.bounds;
    var bekletici:UIActivityIndicatorView?;
    var lblBeklemeSeviyesi:UILabel?;
    
    var resimUrlDizisi=[String]();
    var resimDizisi=[UIImage]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lokacsyonServisleriAyarla();
        lokasyonDuzenleyicisi.delegate=self;
        haritaGoruntuleyicisi.delegate=self;
        ciftTiklamaEkle();
        
        koleksiyonGoruntuleyicisi=UICollectionView(frame: view.bounds , collectionViewLayout: flowLayout);
        koleksiyonGoruntuleyicisi?.register(FotografHucresi.self, forCellWithReuseIdentifier: "fotografHucresi");
        koleksiyonGoruntuleyicisi?.delegate=self;
        koleksiyonGoruntuleyicisi?.dataSource=self;
        koleksiyonGoruntuleyicisi?.backgroundColor=#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1);
        
        ViewFotoğraflar.addSubview(koleksiyonGoruntuleyicisi!);
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func ciftTiklamaEkle(){
        let ciftTiklama=UITapGestureRecognizer(target: self, action: #selector(pinBirak(sender:)));
        ciftTiklama.numberOfTapsRequired=2;
        ciftTiklama.delegate=self;
        haritaGoruntuleyicisi.addGestureRecognizer(ciftTiklama);
    }
    
    func urlleriGetir(annotation:HaritaPini, handler:@escaping (_ durum:Bool)->()) {
        resimUrlDizisi=[];
        Alamofire.request(flickrUrl(apiAnahtari: API_Anahtari, annotation: annotation, fotografSayisi: 40)).responseJSON { (cevap) in
            
            if cevap.error != nil {
                debugPrint("Hata Var!! 66. Satır");
                handler(false);
                return;
            }
            
            
            guard let json=cevap.result.value as? Dictionary<String,AnyObject> else {handler(false);return;}
            let fotograflarJSON=json["photos"] as! Dictionary<String,AnyObject>;
            let fotograflarJSONDizi=fotograflarJSON["photo"] as! [Dictionary<String,AnyObject>];
            var fotografUrl:String;
            for fotograf in fotograflarJSONDizi{
                fotografUrl="https://farm\(fotograf["farm"]!).staticflickr.com/\(fotograf["server"]!)/\(fotograf["id"]!)_\(fotograf["secret"]!)_h_d.jpg";
                self.resimUrlDizisi.append(fotografUrl);
                fotografUrl="";
            }
            
            handler(true);
            
        }
    }
    
    func resimleriGetir(handler:@escaping(_ durum:Bool)->()){
        resimDizisi=[];
        
        for url in resimUrlDizisi{
            Alamofire.request(url).responseImage { (cevap) in
                
                if cevap.error != nil {
                    debugPrint(cevap.error);
                    handler(false);
                    return;
                }
                
                guard let resim=cevap.result.value else{handler(false);return;}
                self.resimDizisi.append(resim);
                
                self.lblBeklemeSeviyesi?.text="\(self.resimDizisi.count)/40 Resim İndirildi";
                
                if self.resimDizisi.count == self.resimUrlDizisi.count{
                    handler(true);
                    return;
                }
            }
        }
        
        
        
    }
    
    func sezonlariBitir(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sezonVeri, yuklenenVeri, indirilenVeri) in
            sezonVeri.forEach({$0.cancel()});
            yuklenenVeri.forEach({$0.cancel()});
            indirilenVeri .forEach({$0.cancel()});

        }
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
        sezonlariBitir();
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
        koleksiyonGoruntuleyicisi?.addSubview(bekletici!);
    }
    
    func bekleticiKaldir(){
        if bekletici != nil {
            bekletici?.removeFromSuperview();
            bekletici=nil;
        }
        
    }
    
    func lblBeklemeSeviyesiEkle(){
        lblBeklemeSeviyesi=UILabel();
        lblBeklemeSeviyesi?.frame=CGRect(x: (ekranBoyutu.width/2)-100, y: 180, width: 200, height: 40);
        lblBeklemeSeviyesi?.font=UIFont(name: "Avenir next", size: 17);
        lblBeklemeSeviyesi?.textColor=#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        lblBeklemeSeviyesi?.textAlignment = .center;
        koleksiyonGoruntuleyicisi?.addSubview(lblBeklemeSeviyesi!);
    }
    
    func lblBeklemeSeviyesiKaldir(){
        if lblBeklemeSeviyesi != nil{
            lblBeklemeSeviyesi?.removeFromSuperview();
            lblBeklemeSeviyesi=nil;
        }
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
        sezonlariBitir();
        pinleriKalidr();
        fotografViewAnimasyonu();
        lblBeklemeSeviyesiKaldir();
        lblBeklemeSeviyesiEkle();
        bekleticiKaldir();
        bekleticiEkle();
        fotografViewGeriyeAnimasyon();
        let dokunulanNokta=sender.location(in: haritaGoruntuleyicisi);
        let dokunulanKoordinat=haritaGoruntuleyicisi.convert(dokunulanNokta, toCoordinateFrom: haritaGoruntuleyicisi);
        
        let annotation=HaritaPini(coordinate: dokunulanKoordinat, identifier: "haritaPini");
        haritaGoruntuleyicisi.addAnnotation(annotation);

        urlleriGetir(annotation: annotation) { (durum) in
            if durum{
                self.resimleriGetir(handler: { (durum) in
                    if durum{
                        self.bekleticiKaldir();
                        self.lblBeklemeSeviyesiKaldir();
                        self.koleksiyonGoruntuleyicisi?.reloadData();
                    }
                })
            }
        }
        
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


extension HaritaVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre=collectionView.dequeueReusableCell(withReuseIdentifier: "fotografHucresi", for: indexPath);
        return hucre;
    }
}
