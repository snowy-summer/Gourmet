//
//  HomeViewSectionModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/20/24.
//

import RxDataSources

struct HomeViewSectionModel {
  var header: String
  var items: [Item]
}

extension HomeViewSectionModel: SectionModelType {
  typealias Item = PostDTO

   init(original: HomeViewSectionModel, items: [Item]) {
    self = original
    self.items = items
  }
}
