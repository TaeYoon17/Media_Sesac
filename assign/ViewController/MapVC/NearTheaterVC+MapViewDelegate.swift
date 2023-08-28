//
//  MapVC+MKMapViewDelegate.swift
//  assign
//
//  Created by 김태윤 on 2023/08/27.
//

import UIKit
import MapKit
extension NearTheaterVC: MKMapViewDelegate{
    @MainActor func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
              if UIApplication.shared.canOpenURL(settingsURL) {
                  UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
              }
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        print(view.annotation)
        print(#function)
        self.v.isNavTabHidden = false
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        self.v.isNavTabHidden = false
    }
}
