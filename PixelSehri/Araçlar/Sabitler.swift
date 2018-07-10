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
    let flickrUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiAnahtari)&license=3%2C1%2C5&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(fotografSayisi)&format=json&nojsoncallback=1";
    return flickrUrl;
}//https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=6efd231c6d03560b70205f8fed8be9b8&license=1%2C2%2C3%2C4%2C5%2C6%2C7%2C8%2C9%2C10&lat=37.785834&lon=122.406417&radius=1&radius_units=miw&per_page=40&format=json&nojsoncallback=1

