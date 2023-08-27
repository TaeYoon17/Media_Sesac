//
//  CollectionViewWrapperCell.swift
//  assign
//
//  Created by 김태윤 on 2023/08/17.
//

import UIKit
import Kingfisher
class CollectionViewWrapperCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var mediaList:[any Media]?{
        didSet{
            guard let mediaList else { return }
            print("mediaList 생성")
            print(mediaList)
            self.collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionViewlayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(.init(nibName: RecommendItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecommendItemCell.identifier)
    }
    
    override func prepareForReuse() {
//        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


extension CollectionViewWrapperCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionViewlayout(){
        DispatchQueue.main.async {
            let flowlayout = UICollectionViewFlowLayout()
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumLineSpacing = 16
            flowlayout.sectionInset = .init(top: 16, left: 20, bottom: 16, right: 20)
            let height = self.bounds.height
            flowlayout.itemSize = .init(width: ( height - 24 ) * 52 / 74 , height: height)
            self.collectionView.collectionViewLayout = flowlayout
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendItemCell.identifier, for: indexPath) as? RecommendItemCell, let list = mediaList else {return .init()}
        let recommend = list[indexPath.row]
        guard let path = recommend.posterPath ?? recommend.backdropPath,
              let url = URL.getImageURL(imgType: .collection, path: path) else { return cell}
        cell.posterImgView.kf.setImage(with: url)
        cell.titleLabel.text = recommend.called
        return cell
    }
    
    
}
