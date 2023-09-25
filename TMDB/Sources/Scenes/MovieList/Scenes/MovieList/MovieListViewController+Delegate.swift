//
//  MovieListViewController+Delegate.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 23/09/2023.
//

import Foundation
import UIKit

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.movies[indexPath.row].id
        let destinationVC = MovieDetailViewController(.init(id: id))
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.count - 5 {
            viewModel.loadMoreData()
        }
    }
}
