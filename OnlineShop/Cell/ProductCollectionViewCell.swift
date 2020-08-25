//
//  ProductCollectionViewCell.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/22.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextView: UITextView!
    @IBOutlet weak var productLikeButton: UIButton!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBAction func productLikeButtonTapped(_ sender: UIButton) {
        let userDefault = UserDefaults.standard
        if let oldList = userDefault.stringArray(forKey: "likeList") {
            if oldList.contains(productNameTextView.text!) {
                var likeList = oldList
                likeList.removeAll { (product) -> Bool in
                    let isMatch = product == productNameTextView.text!
                    return isMatch
                }
                userDefault.setValue(likeList, forKey: "likeList")
                DispatchQueue.main.async {
                    self.productLikeButton.imageView?.image = UIImage(systemName: "heart")
                }
            }else {
                var likeList = oldList
                likeList.append(productNameTextView.text!)
                userDefault.setValue(likeList, forKey: "likeList")
                DispatchQueue.main.async {
                    self.productLikeButton.imageView?.image = UIImage(systemName: "heart.fill")
                }
            }
        }
        
    }
}
