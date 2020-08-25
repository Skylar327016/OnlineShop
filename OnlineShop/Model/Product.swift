//
//  Product.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/22.
//

import Foundation
struct Product: Codable {
    var productName: String
    var productPrice: String
    var imageUrl: String
    var productColors: String
    var productSizeChoices: String
    var productDescription: String
    var numberBeenBought: String
}


enum ProductSize: String {
    case XL = "XL"
    case L = "L"
    case M = "M"
    case S = "S"
 }
