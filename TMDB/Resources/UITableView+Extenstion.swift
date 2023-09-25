//
//  UITableView+Extenstion.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 23/09/2023.
//

import Foundation
import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType.self, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueCell<T: UITableViewCell>(of type: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
}
