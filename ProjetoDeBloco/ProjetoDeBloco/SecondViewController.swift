//
//  SecondViewController.swift
//  ProjetoDeBloco
//
//  Created by md10 on 3/22/16.
//  Copyright © 2016 Yan. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController{

    @IBOutlet weak var campoDistancia: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //campoDistancia.text = "100"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getdistancia() -> Double
    {
        //return Double(campoDistancia.text)
        
        let number1: Double = (campoDistancia.text! as NSString).doubleValue
        
        return number1
    }


}

