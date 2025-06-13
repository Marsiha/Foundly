import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController, UISearchResultsUpdating {
    
    var locationManager: CLLocationManager?
    private var items: [MapItem] = []
    
    private let locationButton = UIButton(type: .system)
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .foundlyPolar
        return view
    }()
    
    private lazy var detailView: ItemDetailView = {
        let view = ItemDetailView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.alpha = 0
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [searchTextView, filterButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "filter")
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .foundlyPrimaryDark
        button.tintColor = .foundlyPolar
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchTextView: UISearchTextField = {
        let search = UISearchTextField()
        search.placeholder = "Поиск"
        search.textColor = .foundlyBlack800
        search.backgroundColor = .foundlySwan
        let icon = UIImage(named: "search")
        let iconView = UIImageView(image: icon)
        iconView.tintColor = .gray
        iconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        search.leftView = iconView
        search.leftViewMode = .always
        return search
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar().isHidden = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap))
        mapView.addGestureRecognizer(tapGesture)
        setupUI()
        setupSearchController()
        setupLocationButton()
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
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Set search bar color
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .systemBlue
        let filterButton = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapFilter)
        )
        navigationItem.rightBarButtonItem = filterButton
        
        definesPresentationContext = true
    }
    
    @objc private func didTapFilter() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        present(filterVC, animated: true)
    }
    
    @objc private func centerOnUserLocation() {
        guard let location = locationManager?.location else { return }
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        print("Searching for: \(searchText)")
    }
    
    @objc private func handleMapTap() {
        UIView.animate(withDuration: 0.3) {
            self.detailView.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAndDisplayItems()
    }
    
    private func fetchAndDisplayItems() {
        AuthService.shared.fetchItemData { items, error in
            if let items = items {
                self.items = items
                DispatchQueue.main.async {
                    self.addItemsToMap(items: items)
                }
            } else if let error = error {
                print("Failed to fetch item data: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func addItemsToMap(items: [MapItem]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for item in items {
            let annotation = ItemAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            annotation.title = item.title
            annotation.item = item
            mapView.addAnnotation(annotation)
        }
    }
    
}

private extension MapViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(mapView)
        //        view.addSubview(headerView)
        //        headerView.addSubview(stackView)
        view.addSubview(detailView)
    }
    
    func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        //        headerView.snp.makeConstraints { make in
        //            make.top.leading.trailing.equalToSuperview()
        //            make.height.equalTo(120)
        //        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(160)
        }
        
        //        stackView.snp.makeConstraints { make in
        //            make.bottom.equalToSuperview().inset(10)
        //            make.leading.trailing.equalToSuperview().inset(30)
        //            make.height.equalTo(40)
        //        }
        
        //        searchTextView.snp.makeConstraints { make in
        //            make.width.equalToSuperview().multipliedBy(0.8)
        //        }
        //
        //        filterButton.snp.makeConstraints { make in
        //            make.width.equalToSuperview().multipliedBy(0.13)
        //            make.top.bottom.equalToSuperview().inset(3)
        //            make.centerY.equalToSuperview()
        //        }
        
    }
    
    @objc func handleFilter() {
        print("hello")
        //        let filterVC = FilterViewController()
        //        filterVC.delegate = self
        //        present(filterVC, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "ItemAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = .systemBlue
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        // Find the tapped item from the data source
        guard let itemAnnotation = annotation as? ItemAnnotation,
              let item = itemAnnotation.item else { return }
        
        detailView.configure(with: item, parentViewContreller: self)
        
        UIView.animate(withDuration: 0.3) {
            self.detailView.alpha = 1
        }
    }
}

extension MapViewController: FilterViewControllerDelegate {
    func didApplyFilters(category: String?, status: String?) {
        print("Filters applied: Category - \(category ?? "None"), Status - \(status ?? "None")")
        // Here, you can implement logic to filter displayed items on the map
    }
}
