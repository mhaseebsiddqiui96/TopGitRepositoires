//
//  GitRepositoryListCell.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import UIKit

class GitRepositoryListCell: UITableViewCell {

    lazy var imageViewAvatar: UIImageView = {
        let imageView = UIImageView()

        imageView.backgroundColor = .lightText
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalToConstant: 40), imageView.widthAnchor.constraint(equalToConstant: 40)])
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.canShimmer = true
        return imageView
    }()
    
    lazy var labelOwner: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "Haseeb"
        label.canShimmer = true
        return label
    }()
    
    lazy var labelRepoName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Swift-Repository-101"
        label.canShimmer = true
        label.textColor = .label

        return label
    }()
    
    lazy var labelRepoDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "Some descriptoiom Some descriptoiom, Some descriptoiom, Some descriptoiom"
        label.canShimmer = true

        return label
    }()
    
    lazy var labelStarCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "12"
        label.canShimmer = true

        return label
    }()
    
    lazy var labelLanguage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "Swift"
        label.canShimmer = true

        return label
    }()
    
    lazy var imageViewStarCount: UIImageView = {
        let starImage = UIImageView()
        starImage.image = UIImage.star
        starImage.image = starImage.image?.withRenderingMode(.alwaysTemplate)
        starImage.tintColor = .label
        
        starImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([starImage.heightAnchor.constraint(equalToConstant: 12), starImage.widthAnchor.constraint(equalToConstant: 12)])
        starImage.canShimmer = true

        return starImage
    }()
    
    lazy var viewLanIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 12), view.widthAnchor.constraint(equalToConstant: 12)])
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.canShimmer = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier:  "\(GitRepositoryListCell.self)")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageViewAvatar.cancelDownload()
        self.imageViewAvatar.image = nil
    }

    
    private func setupView() {
        
        self.canShimmer = true
        self.contentView.canShimmer = true
        
        let topStack = UIStackView(arrangedSubviews: [labelOwner, labelRepoName])
        topStack.axis = .vertical
        topStack.distribution = .fill
        topStack.alignment = .fill
        topStack.spacing = 8
        topStack.canShimmer = true

        
        let starCountStack = UIStackView(arrangedSubviews: [imageViewStarCount, labelStarCount])
        starCountStack.axis = .horizontal
        starCountStack.distribution = .fill
        starCountStack.alignment = .center
        starCountStack.spacing = 8
        starCountStack.canShimmer = true

        
        
        let lanStack = UIStackView(arrangedSubviews: [viewLanIndicator, labelLanguage])
        lanStack.axis = .horizontal
        lanStack.distribution = .fill
        lanStack.alignment = .center
        lanStack.spacing = 8
        lanStack.canShimmer = true
        
        let bottomInnerStack = UIStackView(arrangedSubviews: [lanStack, starCountStack])
        bottomInnerStack.axis = .horizontal
        bottomInnerStack.distribution = .fill
        bottomInnerStack.alignment = .fill
        bottomInnerStack.spacing = 32
        bottomInnerStack.canShimmer = true
        
        let bottomStack = UIStackView(arrangedSubviews: [labelRepoDescription, bottomInnerStack])
        bottomStack.axis = .vertical
        bottomStack.distribution = .fill
        bottomStack.alignment = .leading
        bottomStack.spacing = 20
        bottomStack.canShimmer = true
        
        let mainRightStack = UIStackView(arrangedSubviews: [topStack, bottomStack])
        mainRightStack.axis = .vertical
        mainRightStack.distribution = .fill
        mainRightStack.alignment = .fill
        mainRightStack.spacing = 12
        mainRightStack.canShimmer = true
        
        let mainStack = UIStackView(arrangedSubviews: [imageViewAvatar, mainRightStack])
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        mainStack.alignment = .top
        mainStack.spacing = 8
        mainStack.canShimmer = true
        
        self.contentView.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                                     mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                                     mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                     mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)])
        
    }
    
    func populate(with viewModel: GitRepositoryViewModel) {
        self.labelOwner.text = viewModel.userName
        self.labelLanguage.text = viewModel.language
        self.labelRepoName.text = viewModel.repoName
        self.labelStarCount.text = "\(viewModel.starsCount)"
        self.labelRepoDescription.text = viewModel.repoDescription
        // ideally we should fetch image in prefetch rows method
        self.imageViewAvatar.downLoadImage(with: viewModel.avtarURL)
    }
    
}
