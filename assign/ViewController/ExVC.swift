//
//  ExVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import UIKit

class ExVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        TMDB.Router.Recommend(media: .tv, id: 113962, page: 1).action { (res:MediaResponse) in
//            print(res)
//        }
        TMDB.Router.Recommend(media: .movie, id: 976573, page: 1).action { (res:MediaResponse) in
            print(res)
        }
    }
    
    
    func getEpisode(){
        TMDB.Router.Detail(media: .tv, id: API_Key.sampleTVID)
            .action { (res:TVDetail) in
                let seasons = res.seasons
                print(res.nextEpisodeToAir)
                print(res.lastEpisodeToAir)
                seasons.forEach { season in
                    let id = season.seasonID
                    let number = season.seasonNumber
                    print(id,number)
                    TMDB.Router.TV.season(seriesID: id, seasonNumber: number).action(queue: .main, successCompletion: { (res:SeasonDetail) in
                        print("seasonName:\(res.seasonName)\n-----------\n")
                        res.episodes.forEach { detail in
                            guard !detail.overview.isEmpty else {
                                print(detail.name)
                                return
                            }
                            print("episodeOverview: \(detail.name)\n\(detail.overview)\n------------\n")
                        }
                    }, failHandler: nil)
                }
            }
    }
}
