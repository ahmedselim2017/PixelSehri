//
//  PopVC.swift
//  PixelSehri
//
//  Created by Ahmed Selim Üzüm on 10.07.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit

class PopVC: UIViewController ,UIGestureRecognizerDelegate{

    @IBOutlet weak var popResim: UIImageView!
    
    var resim:UIImage!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popResim.image=resim;
        geriDon();
        // Do any additional setup after loading the view.
    }
    
    func initVeri(resim:UIImage){
        self.resim=resim;
    }
    
    func geriDon(){
        let ciftTiklama=UITapGestureRecognizer(target: self, action: #selector(geriyeDon(sender:)));
        ciftTiklama.numberOfTapsRequired=2;
        ciftTiklama.delegate=self;
        view.addGestureRecognizer(ciftTiklama);
    }
    
    @objc func geriyeDon(sender:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
