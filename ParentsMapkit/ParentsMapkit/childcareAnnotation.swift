
import MapKit

class childcareAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var address: String!
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D?) {
        self.coordinate = (coordinate)!
    }
}
