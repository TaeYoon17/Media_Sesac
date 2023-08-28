//
//  MapView.swift
//  assign
//
//  Created by 김태윤 on 2023/08/28.
//

import SnapKit
import UIKit
import MapKit
import Combine
final class NearTheaterView: BaseView{
    let mapView = MKMapView()
    @Published var isNavTabHidden = false
    weak var navigationController: UINavigationController?{
        didSet{
            guard let navigationController else {return}
            navigationController.navigationItem.rightBarButtonItem = .init(title: "Filter", style: .plain, target: self, action: #selector(Self.filterTapped(_:)))
        }
    }
    convenience init(navigationController:UINavigationController) {
        self.init(frame: .zero)
        self.navigationController = navigationController
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Self.mapTapped)))
        mapView.showsUserLocation = true
    }
    @objc func mapTapped(){ isNavTabHidden.toggle() }
    @objc func filterTapped(_ sender: UIBarButtonItem){
//        self.present(theaterSelector, animated: true)
    }
    override func configureView() {
        self.backgroundColor = .white
        self.addSubview(mapView)
    }
    override func setConstraints() {
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    @MainActor func updateAnootation(remove:[MKAnnotation],append:[MKAnnotation]){
        self.mapView.removeAnnotations(remove)
        self.mapView.addAnnotations(append)
    }
    //MARK: -- 여기 파란 점으로 수정
    @MainActor func setCenterRegionAnnotation(geo:(Double,Double)){
        let center = CLLocationCoordinate2D(latitude: geo.0, longitude: geo.1)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
    }
    @MainActor func setNaviTabHidden(val: Bool){
        print(#function)
        navigationController?.setNavigationBarHidden(val, animated: true)
    }
}
