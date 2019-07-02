//
//  MovieCollectionViewCell.swift
//  TheMovie
//
//  Created by A K on 6/23/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    let posterImageView = UIImageView()
    
    func setup(with movie: Movie) {
        voteAverage.text = String(movie.voteAverage ?? 0)
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        overviewLabel.text = movie.overview
    }

    //MARK: - Private
    private let voteAverage: UILabel = {
        let voteAverage = UILabel()
        voteAverage.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        voteAverage.numberOfLines = 1
        voteAverage.textAlignment = .center
        voteAverage.textColor = UIColor.white
        voteAverage.backgroundColor = UIColor.black
        return voteAverage
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.numberOfLines = 3
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    private let releaseDateLabel: UILabel = {
        let releaseDateLabel = UILabel()
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.numberOfLines = 1
        releaseDateLabel.textColor = UIColor.black
        return releaseDateLabel
    }()
    
    private let overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.numberOfLines = 0
        overviewLabel.font = UIFont.systemFont(ofSize: 12)
        overviewLabel.textColor = UIColor.black
        return overviewLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            } else {
                backgroundColor = UIColor.clear
            }
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            } else {
                backgroundColor = UIColor.clear
            }
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor.white
    }
    
    private func setupLayout() {
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { (make) in
            make.width.equalTo(130)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(posterImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(voteAverage)
        voteAverage.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(posterImageView.snp.right).offset(8)
        }
        
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(voteAverage.snp.right).offset(6)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(overviewLabel)
        overviewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(voteAverage.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.left.equalTo(posterImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
