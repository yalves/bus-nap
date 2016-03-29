//
//  PinAnnotationClass.swift
//  ProjetoDeBloco
//
//  Created by md10 on 3/23/16.
//  Copyright © 2016 Yan. All rights reserved.
//

import MapKit
import Foundation
import UIKit


class PinAnnotation : NSObject, MKAnnotation
{
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D
    {
        get
        {
            return coord
        }
    }
    
    var title: String? = ""
    var subtitle: String? = ""
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D)
    {
        self.coord = newCoordinate
    }
    
    
    func checarDistanciaReferenteAoDestino(destino: CLLocationCoordinate2D, _ localAtual: CLLocation) -> CLLocationDistance
    {
        let locationDestino: CLLocation = CLLocation.init(latitude: destino.latitude, longitude: destino.longitude)
        
        return locationDestino.distanceFromLocation(localAtual)
    }
    
    func estaNaHoraDeAcordar(destino: CLLocationCoordinate2D, _ localAtual: CLLocation, _ distancia: Double) -> Bool
    {
        let locationDestino: CLLocation = CLLocation.init(latitude: destino.latitude, longitude: destino.longitude)
        
        return (Double(locationDestino.distanceFromLocation(localAtual)) <= distancia)
    }
}
