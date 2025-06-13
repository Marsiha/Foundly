import UIKit
import MapKit

class ItemAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            if let itemAnnotation = annotation as? ItemAnnotation {
                markerTintColor = .systemBlue
                glyphText = "📍"
                canShowCallout = false // Disable default callout
            }
        }
    }
}
