//
//  SearchModel.swift
//  assign
//
//  Created by 김태윤 on 2023/08/21.
//

import Foundation
class SearchModel{
    struct SearchItem:Hashable,Comparable{
        let called: String
        let id = UUID()
        func isIncluded(text:String?)->Bool{
            guard let text else {return false}
            return self.called.contains(text)
        }
        static func < (lhs: SearchModel.SearchItem, rhs: SearchModel.SearchItem) -> Bool {
            lhs.called < rhs.called
        }
    }
    private var originItems:[SearchItem] = []
    init?(){
        guard let data = Cache.shared.getMediaList else {return nil}
        self.originItems = data.map { media in SearchItem(called: media.called) }.sorted()
    }
    func queryItems(query: String?)->[SearchItem]{
        guard let query else {return originItems}
        return _getItems(query: query)
    }
}
extension SearchModel{
    func _getItems(query: String)->[SearchItem]{
        let trimmedQuery = query.trimmingCharacters(in: [" ","\n"])
        return self.originItems
            .filter{$0.isIncluded(text: trimmedQuery)}
            .sorted()
    }
}
