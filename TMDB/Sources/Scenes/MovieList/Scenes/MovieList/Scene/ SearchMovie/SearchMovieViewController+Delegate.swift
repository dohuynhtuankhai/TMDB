//
//  SearchMovieViewController+Delegate.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 24/09/2023.
//

import Foundation
import UIKit

extension SearchMovieViewController: UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.getData(query: searchText)
    }
    
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
