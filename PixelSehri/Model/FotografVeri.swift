//
//  FotografVeri.swift
//  PixelSehri
//
//  Created by Ahmed Selim Üzüm on 11.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import Foundation


class PrewievFotografVeri{
    
    var fotografBaslik:String!;
    var fotografAciklama:String!;
    var fotografTarih:String!;
    
    init(fotografBaslik:String,fotografAciklama:String,fotografTarih:String){
        self.fotografTarih=fotografTarih;
        self.fotografBaslik=fotografBaslik;
        self.fotografAciklama=fotografAciklama;
    }
    
}


class JSONFotografVeri{
    
    var id:String;
    var secret:String;
    
    init(id:String,secret:String){
        self.id=id;
        self.secret=secret;
    }
    
    
    
}
