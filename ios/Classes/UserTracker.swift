import Mapbox
import CoreLocation

class UserLocationTracker: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()

    private var controller: TrackerController
    
    private var lastLocation: CLLocation? = nil
    private var movingWithUser = false
    private var isUserMovement = false
    private var moveWithOutsideLocation = false
    
    private var feature: MGLPointFeature? = nil
    private var source: MGLShapeSource? = nil
    
    init(style: MGLStyle, controller: TrackerController) {
        self.controller = controller
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateLocation(nullableLocation: locations.last)
    }
    
    func startTracking() {
        movingWithUser = true
        _forceUpdate(location: lastLocation)
    }
    
    func onStart() {
        if (!moveWithOutsideLocation) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func onStop() {
        if (!moveWithOutsideLocation) {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func onCameraMoved() -> Bool {
        if (isUserMovement) {
            isUserMovement = false
        } else if (movingWithUser) {
            movingWithUser = false
            return true
        }
        return false
    }
    
    func setFeature(feature: MGLPointFeature, source: MGLShapeSource) {
        self.source = source
        self.feature = feature
        _forceUpdate(location: lastLocation)
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

            source?.shape = MGLShapeCollectionFeature(shapes: [feature])

            if (movingWithUser) {
                isUserMovement = true
                controller.moveCamera(location: location)
            }
        }
        lastLocation = location
    }
}

protocol TrackerController {
    func moveCamera(location: CLLocation)
}
