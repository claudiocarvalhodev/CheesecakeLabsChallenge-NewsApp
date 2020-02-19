//
//  ArticleCell.swift
//  News
//
//  Created by claudiocarvalho on 07/01/20.
//  Copyright © 2020 claudiocarvalho. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleCell: UITableViewCell {
    
    // MARK: - Elements
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        addLabelsToStackViewTexts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - Variables

     lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title Label Is Here..."
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Website Label Is Here..."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date Label Is Here..."
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Category Label Is Here..."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = Colors.newsColor
        return label
    }()
    
    lazy var articleImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    lazy var stackViewOne: UIStackView = {
        let stack = UIStackView()
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    
    // MARK: - Functions
    
    func set(article: RealmArticleModel?, indexPath: IndexPath) {
        titleLabel.text = article?.title
        self.setlabelTitleFont(from: article!.readed)
        websiteLabel.text = article?.website
        
        if let tagsResponse = article?.tags {
            for tags in tagsResponse {
                print(tags.category!)
                categoryLabel.text = "#\(tags.category!.uppercased())"
            }
        }
        
        let url = URL(string: (article?.imageUrl)!)
        articleImage.kf.indicatorType = .activity
        articleImage.kf.setImage(
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
    
    func setlabelTitleFont(from readed: Bool) {
        let fontPointSize = self.titleLabel.font.pointSize
        if readed {
            self.titleLabel.textColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
            self.titleLabel.font = UIFont.systemFont(ofSize: fontPointSize, weight: .regular)
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            imgView.image = UIImage(named: "readedmark")!
            imgView.image = imgView.image?.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = Colors.newsColor
            self.accessoryView = imgView
            self.titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
            self.websiteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        } else {
            self.titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.titleLabel.font = UIFont.systemFont(ofSize: fontPointSize, weight: .semibold)
            self.accessoryView = .none
            self.titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            self.websiteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        }
    }
    
    func setupView(){
        backgroundColor = UIColor.white
        addSubview(articleImage)
        addSubview(stackViewOne)
        addSubview(categoryLabel)
        addSubview(titleLabel)
        addSubview(websiteLabel)
    }
    
    func addLabelsToStackViewTexts() {
        stackViewOne.addArrangedSubview(categoryLabel)
        stackViewOne.addArrangedSubview(titleLabel)
        stackViewOne.addArrangedSubview(websiteLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            // Add constraints
            articleImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            articleImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            articleImage.heightAnchor.constraint(equalToConstant: 80),
            articleImage.widthAnchor.constraint(equalTo: articleImage.heightAnchor, multiplier: 16/9),
            
            stackViewOne.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackViewOne.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: 16),
            stackViewOne.heightAnchor.constraint(equalToConstant: 80),
            stackViewOne.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
