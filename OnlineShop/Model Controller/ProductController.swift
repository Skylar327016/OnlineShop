//
//  ProductController.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/22.
//

import Foundation
import UIKit
struct ProductController {
    static let shared = ProductController()
    static let jsonUrl = "https://spreadsheets.google.com/feeds/list/1Egh0qKg4fpLZuuSNq6LxJ_UsdQP7C2S_95FtMOLu98o/od6/public/values?alt=json"
    
    func fetechData(with completion: @escaping ([Product]?) -> Void) {
        guard let url = URL(string: ProductController.jsonUrl) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            let decoder = JSONDecoder()
            if let data = data, let loadedJson = try? decoder.decode(JsonStructure.self, from: data) {
                //這行確定好要放外面
                var products = [Product]()
                let entry = loadedJson.feed.entry
                entry.forEach { (entry) in
                    let productName = entry.productName.value
                    let productPrice = entry.productPrice.value
                    let imageUrl = entry.imageUrl.value
                    let productColors = entry.productColors.value
                    let productSizeChoices = entry.productSizeChoices.value
                    let productDescription = entry.productDescription.value
                    let numberBeenBought = entry.numberBeenBought.value
                    let product = Product(productName: productName, productPrice: productPrice, imageUrl: imageUrl, productColors: productColors, productSizeChoices: productSizeChoices, productDescription: productDescription, numberBeenBought: numberBeenBought)
                    products.append(product)
                }
                completion(products)
            }
            
        }.resume()
    }
    func loadProductImage(with imageUrl: String) -> UIImage {
        guard let url = URL(string: imageUrl) else {return UIImage(named: "noImage")!}
        let tempDirectory = FileManager.default.temporaryDirectory
        let imageFileUrl = tempDirectory.appendingPathComponent(url.lastPathComponent)
        if FileManager.default.fileExists(atPath: imageFileUrl.path) {
            let image = UIImage(contentsOfFile: imageFileUrl.path)!
            return image
        }else {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {return UIImage(named: "noImage")!}
            try? data.write(to: imageFileUrl)
            return image
        }
        
    }
    
    func fetchProductColor(with productColors: String, completion: ([String]?) -> Void){
        let colors = productColors.components(separatedBy: ",")
        completion(colors)
    }
    func getProductSize(with selectedSegmentIndex: Int) -> String{
        switch selectedSegmentIndex {
        case 0:
            return "S"
        case 1:
            return "M"
        case 2:
            return "L"
        case 3:
            return "XL"
        default:
            return ""
        }
    }
    
}
