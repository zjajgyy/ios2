//
//  POIAnnotation.swift
//  T-Helper
//
//  Created by zjajgyy on 2016/11/30.
//  Copyright © 2016年 thelper. All rights reserved.
//

import Foundation
import MapKit

class POIAnnotation: NSObject, MKAnnotation {
    var placemark: MKPlacemark?
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, placemark: MKPlacemark?) {
        self.coordinate = coordinate
        self.placemark = placemark
        self.title = title
        self.subtitle = subtitle
    }
}

