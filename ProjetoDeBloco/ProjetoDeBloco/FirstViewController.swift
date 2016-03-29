//
//  FirstViewController.swift
//  ProjetoDeOnibus
//
//  Created by md10 on 3/22/16.
//  Copyright © 2016 Yan. All rights reserved.
//

import MapKit
import Foundation
import UIKit
import AudioToolbox.AudioServices
import AVFoundation


class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var labelDistancia: UILabel!
    @IBOutlet weak var Mapa: MKMapView!
    @IBOutlet weak var btnDelete: UIButton!
    
    let locationManager = CLLocationManager()
    var distancia: Double = SecondViewController().getdistancia()
    
    override func viewDidLoad() {
        super.viewDidLoad()       
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("alarme", ofType: "wav")!), fileTypeHint:nil)
        } catch {
            //Handle the error
        }
        
        audioPlayer.prepareToPlay()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 45.612125, longitude: 22.948280)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        Mapa.setRegion(theRegion, animated: true)
        
        let tap = UITapGestureRecognizer(target: self, action: "action:")
        tap.numberOfTapsRequired = 1
        Mapa.addGestureRecognizer(tap)
        Mapa.delegate = self
        
        
        let regionZone = MKCoordinateRegionMake(locationManager.location!.coordinate, MKCoordinateSpanMake(0.01, 0.01))
        Mapa.setRegion(regionZone, animated: true)
        
        
    }
    
    @IBAction func deletarPin(sender: AnyObject)
    {
        Mapa.removeAnnotation(newAnotation)
    }
    
    
    let newAnotation = PinAnnotation()
    
    // Grab the path, make sure to add it to your project!
    //var somAlarme = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("alarme", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    
   
    
    
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.locationInView(self.Mapa)
        let newCoord:CLLocationCoordinate2D = Mapa.convertPoint(touchPoint, toCoordinateFromView: self.Mapa)
        locationManager.startUpdatingLocation()
        
        newAnotation.setCoordinate(newCoord)
        newAnotation.title = "Você vai acordar aqui!"
        
        Mapa.addAnnotation(newAnotation)
        //Mapa.selectAnnotation(newAnotation, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
    
    
    
        
    
// *********************************************************** || DELEGATES || ***************************************************************
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        //let regionZone = MKCoordinateRegionMake(manager.location!.coordinate, MKCoordinateSpanMake(0.01, 0.01))
        //Mapa.setRegion(regionZone, animated: true)
        
        newAnotation.subtitle = "Faltam " + String(format:"%.02f", newAnotation.checarDistanciaReferenteAoDestino(newAnotation.coordinate, locationManager.location!)) + " Metros"
        labelDistancia.text = "Faltam " + String(format:"%.02f", newAnotation.checarDistanciaReferenteAoDestino(newAnotation.coordinate, locationManager.location!)) + " Metros"
        
        if(newAnotation.estaNaHoraDeAcordar(newAnotation.coordinate, locationManager.location!, distancia))
        {
            manager.stopUpdatingLocation()
            audioPlayer.play()
            AudioServicesPlaySystemSound(1352)//(kSystemSoundID_Vibrate)
    
            let alert = UIAlertController(title: "CHEGOU MALUCO!", message: "ACORDA AE!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "PARA DE TOCAR ESSA MERDA", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in self.audioPlayer.stop()}))
            self.presentViewController(alert, animated: true, completion: nil)
            //audioPlayer.stop()
            //audioPlayer.prepareToPlay()
        }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.Mapa.showsUserLocation = true
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            //pinAnnotationView.pinTintColor = UIColor.blueColor()
            //pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.backgroundColor = UIColor.clearColor()
            pinAnnotationView.image = UIImage(named: "pin.png")
            //pinAnnotationView.animatesDrop = true
            
            let deleteButton = UIButton(type: UIButtonType.System) as UIButton
            deleteButton.frame.size.width = 44
            deleteButton.frame.size.height = 44
            deleteButton.backgroundColor = UIColor.clearColor()
            deleteButton.setImage(UIImage(named: "delete.png"), forState: .Normal)
            deleteButton.tintColor = UIColor.redColor()

            
            pinAnnotationView.leftCalloutAccessoryView = deleteButton
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PinAnnotation {
            mapView.removeAnnotation(annotation)
        }
    }
    
}
