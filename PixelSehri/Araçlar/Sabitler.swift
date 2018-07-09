//
//  Sabitler.swift
//  PixelSehri
//
//  Created by Ahmed Selim Üzüm on 9.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import Foundation

let API_Anahtari="0bc8f6d4045c198faf788232f6e1c4dd";

func flickrUrl(apiAnahtari:String,annotation:HaritaPini,fotografSayisi:Int)->String{
    let flickrUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiAnahtari)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(fotografSayisi)&format=json&nojsoncallback=1";
    
    return flickrUrl;
}

