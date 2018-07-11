//
//  HaritaPini.swift
//  PixelSehri
//
//  Created by Ahmed Selim Üzüm on 9.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit;
import MapKit;


class HaritaPini: NSObject,MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier:String;
    
    init(coordinate:CLLocationCoordinate2D,identifier:String) {
        self.coordinate=coordinate;
        self.identifier=identifier;
        super.init();
    }
    
}
