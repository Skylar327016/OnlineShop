//
//  FavoriteListManager.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/27.
//

import Foundation
struct FavoriteListManager {
    static var shared = FavoriteListManager(favoriteList: [String]())
    var favoriteList:[String]
}
