//
//  ShoppingcartTableViewCellDelegate.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/25.
//

import Foundation
protocol ShoppingcartTableViewCellDelegate {
    func showMessage()
    func confirmAction(with completionHandler: @escaping (Bool?) -> Void)
}
