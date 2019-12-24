import Mapbox

class ImageConverter {
    class func convert(_ arguments: [String: Any], style: MGLStyle) -> Bool {
        guard let id = arguments["id"] as? String, let type = arguments["type"] as? String, let properties = arguments["properties"] as? [String] else {
            return false
        }
        
        switch type {
        case "busstop-image":
            style.setImage(#imageLiteral(resourceName: "paradero"), forName: id)
            return true
        default:
            return false
        }
    }
}

class FeatureConverter {
    class func convert(raw: String) -> [MGLPointFeature]? {
        var list = [MGLPointFeature]()
        let data = raw.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
                jsonArray.forEach { jsonData in
                    if let id = jsonData["id"] as? String, let latitude = jsonData["latitude"] as? Double, let longitude = jsonData["longitude"] as? Double {
                        
                        let feature = MGLPointFeature()
                        feature.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        feature.identifier = id
                        
                        if let properties = jsonData["properties"] as? Dictionary<String, Any> {
                            feature.attributes = properties
                        } else {
                            NSLog("no properties")
                        }
                        
                        //NSLog(feature.geoJSONDictionary().description)
                        
                        list.append(feature)
                    }
                }
                
            } else {
                return nil
            }
        } catch _ as NSError {
            return nil
        }
        return list
    }
}

class SourceConverter {
    class func convert(_ arguments: [String: Any]) -> MGLShapeSource? {
        let id = arguments["id"] as! String
        return MGLShapeSource(identifier: id, features: [], options: nil)
    }
}
class SymbolLayerConverter {
    class func convert(_ arguments: [String: Any], style: MGLStyle) -> MGLSymbolStyleLayer? {
        guard let source = style.source(withIdentifier: arguments["source"] as! String) else {
            return nil
        }
        let id = arguments["id"] as! String
        let symbolLayer = MGLSymbolStyleLayer(identifier: id, source: source)

        guard let properties = arguments["properties"] as? [String] else {
            return nil
        }

        properties.forEach { rawProperty in
            LayerPropertyConverter.convert(rawProperty, symbolLayer)
        }

        if let minZoom = arguments["minZoom"] as? Float {
            symbolLayer.minimumZoomLevel = minZoom
        }
        if let maxZoom = arguments["maxZoom"] as? Float {
            symbolLayer.maximumZoomLevel = maxZoom
        }

        symbolLayer.iconImageName = NSExpression(forKeyPath: "image")

        return symbolLayer
     }
 }

class LayerPropertyConverter {
     class func convert(_ rawProperty: String, _ symbolLayer: MGLSymbolStyleLayer) {
        let data = rawProperty.split(separator: ";")
        switch(data[0]) {
            case "iconSize":
                symbolLayer.iconScale = NSExpression(forConstantValue: Float(data[1]))
            case "iconAllowOverlap":
                symbolLayer.iconAllowsOverlap = NSExpression(forConstantValue: Bool(String(data[1])))
            case "iconOffset":
                if let dx = NumberFormatter().number(from: String(data[1])), let dy = NumberFormatter().number(from: String(data[2])) {
                    symbolLayer.iconOffset = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: CGFloat(dx), dy: CGFloat(dy))))
                }
            default:
                return
        }
    }
}
