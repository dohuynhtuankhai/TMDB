//
//  BaseViewController.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 23/09/2023.
//

import Foundation
import UIKit
import Toast

public class BaseViewController: UIViewController {
    public var screenName: String? { return nil }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationTitle()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func configureNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        self.title = screenName
    }
    
    func showToast(message: String) {
        let toast = Toast.text(message)
        toast.show()
    }
}
