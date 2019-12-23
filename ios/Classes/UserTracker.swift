//
//  UserLocationTracker.swift
//  location
//
//  Created by Agustin Antoine on 12/23/19.
//

import Mapbox
import CoreLocation

class UserLocationTracker: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    var source: MGLShapeSource
    
    private var _moveWithUser = false
    private var _moveWithOutsideLocation = false
    private var feature: MGLPointFeature? = nil
    private var lastLocation: CLLocation? = nil
    
    private var controller: TrackerController
    
    init(style: MGLStyle, controller: TrackerController) {
        self.controller = controller
        self.source = MGLShapeSource(identifier: "user-source", features: [], options: nil)
        let symbols = MGLSymbolStyleLayer(identifier: "user-layer-id", source: source)
        
        symbols.iconImageName = NSExpression(forKeyPath: "image")
        symbols.iconScale = NSExpression(forConstantValue: 0.6)
        symbols.iconOffset = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: -20)))
        symbols.iconAllowsOverlap = NSExpression(forConstantValue: true)
        
        super.init()
        
        style.addSource(source)
        style.setImage(#imageLiteral(resourceName: "userLocation"), forName: "user-image")
        style.addLayer(symbols)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateLocation(nullableLocation: locations.last)
    }
    
    func onStart() {
        if (!_moveWithOutsideLocation) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func onStop() {
        if (!_moveWithOutsideLocation) {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func moveWithUser(move: Bool) {
        _moveWithUser = move
        if (move) {
            _forceUpdate(location: lastLocation)
        }
    }
    
    func updateLocation(nullableLocation: CLLocation?) {
        if let location = nullableLocation {
            if let lastLocation = lastLocation {
                if lastLocation.distance(from: location) > -1 {
                    forceUpdate(location: location)
                }
            } else {
                forceUpdate(location: location)
            }
        }
    }
    
    private func _forceUpdate(location: CLLocation?) {
        if let location = location {
            forceUpdate(location: location)
        }
    }
    
    private func forceUpdate(location: CLLocation) {
        if let feature = feature {
            feature.coordinate = location.coordinate

            source.shape = MGLShapeCollectionFeature(shapes: [feature])

            if (_moveWithUser) {
                controller.onUserMovement(location: location)
            }
        }
        lastLocation = location
    }
    
    func updateFeature(feature: MGLPointFeature) {
        self.feature = feature
        _forceUpdate(location: lastLocation)
    }
}

protocol TrackerController {
    func onUserMovement(location: CLLocation)
}
