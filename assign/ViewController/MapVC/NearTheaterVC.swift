//
//  Mapvc.swift
//  assign
//
//  Created by 김태윤 on 2023/08/27.
//

import UIKit
import SnapKit
import Combine
import MapKit
class NearTheaterVC: UIViewController{
    lazy var v = NearTheaterView()
    private let locationService = LocationService.shared
    private let theaterModel = TheaterModel()
    private var theaterAnnotations: [(TheaterItem,MKPointAnnotation)] = []
    private var subscription = Set<AnyCancellable>()
    override func loadView() {
        self.navigationItem.title = "지도입니다~"
        self.navigationItem.rightBarButtonItem = .init(title: "필터", style: .plain, target: self, action: #selector(Self.rightBtnTapped(_:)))
        self.view = v
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSubscription()
        viewSubscription()
        setMarker(companies: TheaterCompany.allCases)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    func locationSubscription(){
        locationService.checkDeviceLocationAuthorization {[weak self] in
            try? self?.locationService.startUpdatingLocation(duration: 3)
        } failed: {[weak self] in
            self?.showRequestLocationServiceAlert()
            self?.v.setCenterRegionAnnotation(geo: (37.5176,126.8864))
        }
        locationService.locationPassthrough
            .subscribe(on: DispatchQueue.main).sink { completion in
            switch completion{
            case .finished: print("finished")
            case .failure(let err): print(err)
            }
        } receiveValue: {[weak self] (latitude: Double, longtitude: Double) in
            self?.v.setCenterRegionAnnotation(geo: (latitude,longtitude))
        }.store(in: &subscription)
    }
    func viewSubscription(){
        self.v.mapView.delegate = self
        self.v.$isNavTabHidden.debounce(for: .seconds(0.6), scheduler: DispatchQueue.main)
            .sink {[weak self] val in
                self?.navigationController?
                    .setNavigationBarHidden(val, animated: true)
            }
            .store(in: &subscription)
    }
}
extension NearTheaterVC{
    func setMarker(companies:[TheaterCompany]){
        DispatchQueue.global().async {
            self.theaterModel.queryTheaters(companies: companies)
            var removeAnnos:[MKAnnotation] = []
            var appendAnnos:[MKAnnotation] = []
            // 없앨 아이템의 어노테이션은 removeAnnos 배열에 추가하고 안 없앨 것들은 아이템 정보만 남긴다.
            let filteredItems = self.theaterAnnotations.filter({ (item,anno) in
                if companies.contains(item.company){ return true
                }else{
                    removeAnnos.append(anno)
                    return false
                }
            }).map{$0.0}
            // 새로 받은 아이템 중 중복되지 않은 것만 남긴다.
            let needAppendAnnotationItems:Set<TheaterItem> = Set(self.theaterModel.theaterList).subtracting(filteredItems)
            // 새로운 아이템을 어노테이션과 저장할 배열과 appendAnnos 배열에 추가한다.
            let newTheaterAnnotations: [(TheaterItem,MKPointAnnotation)] = needAppendAnnotationItems.map { item in
                let annotation = { // 애플이 기본 만들어 놓은 어노테이션
                    let anno = MKPointAnnotation()
                    anno.title = item.locationName
                    anno.coordinate = .init(latitude: item.geo.latitude, longitude: item.geo.longtitude)
                    return anno
                }()
                appendAnnos.append(annotation)
                return (item,annotation)
            }
            self.theaterAnnotations.append(contentsOf: newTheaterAnnotations)
            DispatchQueue.main.async { // 여기에 나중에 뷰 애니메이션 추가하면 될 듯
                self.v.updateAnootation(remove: removeAnnos, append: appendAnnos)
            }
        }
    }
}
extension NearTheaterVC{
    var theaterSelector: UIAlertController{
        let alert = UIAlertController(title: "영화관을 선택하세요", message: nil, preferredStyle: .actionSheet)
        TheaterCompany.allCases.forEach { company in
            alert.addAction(.init(title: company.rawValue, style: .default){[weak self] _ in
                self?.setMarker(companies: [company])
            })
        }
        alert.addAction(.init(title:"전체보기",style:.default){[weak self] _ in
            self?.setMarker(companies: TheaterCompany.allCases)
        })
        alert.addAction(.init(title: "뒤로가기", style: .cancel))
        return alert
    }
    @objc func rightBtnTapped(_ sender: UIBarButtonItem){
        self.present(theaterSelector,animated: true)
    }
}
/// 문제점: MVC 아키텍처를 준수하기 위한 문제점
/// 1. View에 Published를 사용해도 괜찮나? View가 VC를 모르게 사용하기 위한 방법...
/// 2. View가 제스처 관련 메서드를 알아도 되는가? -> 이 방법을 안 사용하고 처리하려면 결국 VC 자체를 delegate 해야할 것 같은데...
/// 3. View가 navigationController를 알아도 괜찮나? -> 뷰 관련 동작인 setNavigationBarHidden(val, animated: true)을 VC가 처리해야함
