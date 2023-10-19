import MapKit
import CoreLocation.CLLocation

extension Array where Element == CLLocationCoordinate2D {
    func wmf_boundingRegion(with boundingMetersPerPoint: Double) -> MKCoordinateRegion {
        var rect: MKMapRect?
        for coordinate in self {
            let point = MKMapPoint(coordinate)
            let mapPointsPerMeter = MKMapPointsPerMeterAtLatitude(coordinate.latitude)
            let dimension = mapPointsPerMeter * boundingMetersPerPoint
            let size = MKMapSize(width: dimension, height: dimension)
            let coordinateRect = MKMapRect(origin: MKMapPoint(x: point.x - 0.5*dimension, y: point.y - 0.5*dimension), size: size)
            guard let currentRect = rect else {
                rect = coordinateRect
                continue
            }
            rect = currentRect.union(coordinateRect)
        }
        
        guard let finalRect = rect else {
            return MKCoordinateRegion()
        }
        
        var region = MKCoordinateRegion(finalRect)
        if region.span.latitudeDelta < 0.01 {
            region.span.latitudeDelta = 0.01
        }
        if region.span.longitudeDelta < 0.01 {
            region.span.longitudeDelta = 0.01
        }
        return region
    }
}

extension CLLocation {
    /// A convenient way to display user-friendly formatted location value using ISO 6709 standard.
    /// Example:
    /// "22°54'48"S 43°12'2"W"
    var isoFormattedString: String { latitude + " " + longitude }

    private var latitude: String {
        let (degrees, minutes, seconds) = coordinate.latitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "N" : "S")
    }

    private var longitude: String {
        let (degrees, minutes, seconds) = coordinate.longitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "E" : "W")
    }
}

private extension BinaryFloatingPoint {
    var dms: (degrees: Int, minutes: Int, seconds: Int) {
        var seconds = Int(self * 3600)
        let degrees = seconds / 3600
        seconds = abs(seconds % 3600)
        return (degrees, seconds / 60, seconds % 60)
    }
}
