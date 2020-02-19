//
//  ArticlesListViewController.swift
//  News
//
//  Created by claudiocarvalho on 07/01/20.
//  Copyright © 2020 claudiocarvalho. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper
import Localize_Swift

class ArticlesListViewController: UIViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func loadView() {
        view = ArticlesListView(frame: UIScreen.main.bounds)
    }
    
    // MARK: - Properties
    
    let realm = try! Realm()
    var articlesDataSource : Results<RealmArticleModel>?
    var filteredTitles = [RealmArticleModel]()
    var sortArticles = [RealmArticleModel]()
    
    
    // MARK: - Variables
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 130
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(ArticleCell.self, forCellReuseIdentifier: Cells.articleCell)
        return table
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.scopeButtonTitles = ["All", "Politics", "Tech", "Science", "Sports"]
        return searchController
    }()
    
    
    // MARK: - Methods
    
    func getArticles() {
        FetchData.get(type: RealmArticleModel.self, success: {
            self.articlesDataSource = self.realm.objects(RealmArticleModel.self)
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setupElements() {
        self.title = Strings.News
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .done, target: self, action: #selector(self.buttonSortAction))
        getArticles()
        configureSearchController()
        view.addSubview(tableView)
        tableView.edgeTo(view, safeArea: .all)
    }
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTitles = (articlesDataSource?.filter({ (article: RealmArticleModel?) -> Bool in
            if let tagsResponse = article?.tags {
                for tags in tagsResponse {
                    let doesCategoryMatch = (scope == "All") || (tags.category == scope)
                    if isSearchBarEmpty() {
                        return doesCategoryMatch
                    } else {
                        return doesCategoryMatch && (article?.title?.lowercased().contains(searchText.lowercased()))!
                    }
                }
            }
            return true
        }))!
        tableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
    // MARK: - Button
    
    @objc func buttonSortAction() {
        let sortArticles = articlesDataSource
        print("Test: \((sortArticles)!)")
           
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Title", style: .default, handler: { [weak self] (alertAction:UIAlertAction) in
           guard let `self` = self else { return }
           self.sortArticles = SortArticleService.sortedByTitleAscending(articles: self.sortArticles)
           self.tableView.reloadData()
        }))

        alertController.addAction(UIAlertAction(title: "Website", style: .default, handler: { [weak self] (alertAction:UIAlertAction) in
           guard let `self` = self else { return }
           self.sortArticles = SortArticleService.sortedByWebsiteAscending(articles: self.sortArticles)
           self.tableView.reloadData()
        }))

        alertController.addAction(UIAlertAction(title: "Authors", style: .default, handler: { [weak self] (alertAction:UIAlertAction) in
            guard let `self` = self else { return }
           self.sortArticles = SortArticleService.sortedByAuthorsAscending(articles: self.sortArticles)
            self.tableView.reloadData()
        }))

        alertController.addAction(UIAlertAction(title: "Date", style: .default, handler: { [weak self] (alertAction:UIAlertAction) in
           guard let `self` = self else { return }
           self.sortArticles = SortArticleService.sortedByDateDescending(articles: self.sortArticles)
           self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true)
    }
}


// MARK: - SearchBar Delegates

extension ArticlesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
       filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ArticlesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       let searchBar = searchController.searchBar
       let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
       filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}


// MARK: - TableView Delegates

extension ArticlesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() { return filteredTitles.count }
        return articlesDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.articleCell) as? ArticleCell else { return UITableViewCell() }
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        
        let currentArticle: RealmArticleModel
        if isFiltering() {
           currentArticle = filteredTitles[indexPath.row]
        } else {
           currentArticle = articlesDataSource![indexPath.row]
        }
        let article = currentArticle
        cell.set(article: article, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = articlesDataSource?[indexPath.row] else{
            return
        }
        article.readed = true
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let articleDetailsViewController = ArticleDetailsViewController()
        articleDetailsViewController.article = article
        self.navigationController!.pushViewController(articleDetailsViewController, animated: true)
    }
}
