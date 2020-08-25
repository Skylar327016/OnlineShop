//
//  JsonStructure.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/23.
//

import Foundation
struct JsonStructure: Codable {
    var feed: Feed
}
struct Feed: Codable {
    var entry: [Entry]
}
struct Entry: Codable {
    var productName: ProductName
    var productPrice: ProductPrice
    var imageUrl: ImageUrl
    var productColors: ProductColors
    var productSizeChoices: ProductSizeChoices
    var productDescription: ProductDescription
    var numberBeenBought: NumberBeenBought
    enum CodingKeys: String, CodingKey {
        case productName = "gsx$productname"
        case productPrice = "gsx$productprice"
        case imageUrl = "gsx$imageurl"
        case productColors = "gsx$productcolors"
        case productSizeChoices = "gsx$productsizechoices"
        case productDescription = "gsx$productdescription"
        case numberBeenBought = "gsx$numberbeenbought"
    }
}
struct ProductName: Codable {
    var value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
struct ProductPrice: Codable {
    var value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
struct ImageUrl: Codable {
    var value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
struct ProductColors: Codable {
    var value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
struct ProductSizeChoices: Codable {
    var value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
struct ProductDescription: Codable {
    var value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
struct NumberBeenBought: Codable {
    var value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}





