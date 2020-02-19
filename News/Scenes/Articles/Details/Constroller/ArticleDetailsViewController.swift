//
//  ArticleDetailsViewController.swift
//  News
//
//  Created by claudiocarvalho on 07/01/20.
//  Copyright © 2020 claudiocarvalho. All rights reserved.
//

import UIKit
import ObjectMapperAdditions
import Localize_Swift

class ArticleDetailsViewController: UIViewController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        showDetails()
    }
    
    override func loadView() {
        view = ArticleDetailsView(frame: UIScreen.main.bounds)
    }
    
    
    // MARK: - Properties
    
    var uiDetailsView: ArticleDetailsView! { return self.view as? ArticleDetailsView }
    var article: RealmArticleModel?
    
    
    // MARK: - Variables

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title label"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Website label"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Author label"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date label"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Content label"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Category label"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = Colors.newsColor
        return label
    }()
    
    lazy var articleImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    lazy var view1: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var view2: UIView = {
        let view = UIView()
        return view
    }()
    
    let scrollView = DScrollView()
    let scrollViewContainer = DScrollViewContainer(axis: .vertical, spacing: 10)
    let scrollViewElement = DScrollViewElement(height: 1200, backgroundColor: .purple)
    
    
    // MARK: - Methods
    
    func setupElements() {
        self.title = Strings.Details
        view.addScrollView(scrollView,
                           withSafeArea: .vertical,
                           hasStatusBarCover: true,
                           statusBarBackgroundColor: .clear,
                           container: scrollViewContainer,
                           elements: [articleImage.withHeight(300),
                                      view1.VStack(categoryLabel,
                                                   titleLabel,
                                                   view2.HStack(websiteLabel,
                                                                dateLabel,
                                                                distribution: .fill),
                                                   authorLabel,
                                                   contentLabel,
                                                   spacing: 8,
                                                   distribution: .fill).padding([.left, .right], amount: 16)])
    }
    
    func showDetails() {
        self.titleLabel.text = article?.title
        self.websiteLabel.text = "\((article?.website)!) - "
        self.authorLabel.text = "By: \((article?.author)!)"
        self.dateLabel.text = ISO8601JustDateTransform().transformToJSON(article?.date)!
        self.contentLabel.text = article?.content
        
        if let tagsResponse = article?.tags {
            for tags in tagsResponse {
                print(tags.category!)
                categoryLabel.text = "#\(tags.category!.uppercased())"
            }
        }
        
        let url = URL(string: (article?.imageUrl)!)
        self.articleImage.kf.indicatorType = .activity
        self.articleImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
