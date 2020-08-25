//
//  CartItem.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/24.
//

import Foundation
struct CartItem: Equatable, Codable {
    var itemImageUrl: String
    var itemName: String
    var itemColor: String
    var itemSize: String
    var itemQuantity: String
    var itemPrice: String
    var subtotal: String
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        if lhs.itemImageUrl == rhs.itemImageUrl && lhs.itemName == rhs.itemName && lhs.itemColor == rhs.itemColor && lhs.itemSize == rhs.itemSize && lhs.itemPrice == rhs.itemPrice {
            return true
        }else{
            return false
        }
    }
}

