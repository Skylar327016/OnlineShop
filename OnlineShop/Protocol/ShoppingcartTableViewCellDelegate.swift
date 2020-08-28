//
//  ShoppingcartTableViewCellDelegate.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/25.
//

import Foundation
protocol ShoppingcartTableViewCellDelegate {
    func showMessage(with message:String)
    func confirmAction(with completionHandler: @escaping (Bool?) -> Void)
}
