import UIKit
import MapKit
import CoreLocation

class MapPickerViewController: UIViewController {
    
    // MARK: - UI Components
    private let mapView = MKMapView()
    private let locationButton = UIButton(type: .system)
    private let bottomView = UIView()
    private let addressLabel = UILabel()
    private let doneButton = UIButton(type: .system)
    
    // MARK: - Location
    private let locationManager = CLLocationManager()
    private var selectedCoordinate: CLLocationCoordinate2D?
    private var selectedAddress: String?
    var onAddressSelected: ((String, CLLocationCoordinate2D) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMapView()
        setupLocationManager()
        setupLocationButton()
        setupBottomView()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        mapView.pointOfInterestFilter = .includingAll
        mapView.userTrackingMode = .follow
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupLocationButton() {
        locationButton.setImage(UIImage(named: "location"), for: .normal)
        locationButton.tintColor = .foundlyBlack800
        locationButton.backgroundColor = .foundlyPolar
        locationButton.layer.cornerRadius = 10
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addTarget(self, action: #selector(centerOnUserLocation), for: .touchUpInside)
        view.addSubview(locationButton)
        
        NSLayoutConstraint.activate([
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupBottomView() {
        bottomView.backgroundColor = .secondarySystemBackground
        bottomView.layer.cornerRadius = 16
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(bottomView)
        
        addressLabel.numberOfLines = 0
        addressLabel.font = .systemFont(ofSize: 16)
        addressLabel.textAlignment = .left
        bottomView.addSubview(addressLabel)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .systemBlue
        doneButton.layer.cornerRadius = 8
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        bottomView.addSubview(doneButton)
        
        // SnapKit constraints
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(150)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        bottomView.isHidden = true
    }
    
    
    // MARK: - Actions
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            selectedCoordinate = coordinate
            
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Выбранный адрес"
            mapView.addAnnotation(annotation)
            
            reverseGeocode(coordinate)
        }
    }
    
    @objc private func centerOnUserLocation() {
        guard let location = locationManager.location else { return }
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func doneTapped() {
        guard let address = selectedAddress,
              let coordinate = selectedCoordinate else {
            print("❌ Missing selected address or coordinates")
            return
        }
        
        print("✅ DONE TAPPED - Selected address: \(address)")
        onAddressSelected?(address, coordinate)
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("❌ Reverse geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var addressParts: [String] = []
            
            if let name = placemark.name { addressParts.append(name) }
            if let street = placemark.thoroughfare { addressParts.append(street) }
            if let subLocality = placemark.subLocality { addressParts.append(subLocality) }
            if let city = placemark.locality { addressParts.append(city) }
            
            let fullAddress = addressParts.joined(separator: ", ")
            self.selectedAddress = fullAddress
            self.addressLabel.text = fullAddress
            self.bottomView.isHidden = false
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapPickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapPickerViewController: MKMapViewDelegate {}
