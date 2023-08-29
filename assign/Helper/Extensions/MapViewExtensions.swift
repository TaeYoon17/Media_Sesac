//
//  MapViewExtensions.swift
//  assign
//
//  Created by 김태윤 on 2023/08/28.
//

import Foundation
import MapKit


extension MKMapView{
    @MainActor func setCenterRegionAnnotation(geo:(Double,Double)){
        let center = CLLocationCoordinate2D(latitude: geo.0, longitude: geo.1)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 400, longitudinalMeters: 400)
        self.setRegion(region, animated: true)
    }
}

