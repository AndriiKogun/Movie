//
//  FilterTableViewCell.swift
//  Movie
//
//  Created by A K on 7/2/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    func setup(with text: String?) {
        titleLabel.text = text
    }
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return titleLabel
    }()
    
    private var checkmarkImageView: UIImageView = {
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = UIImage(named: "selected_icon")
        checkmarkImageView.tintColor = UIColor.black
        return checkmarkImageView
    }()

    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.gray
        return separatorView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.white
        self.selectedBackgroundView = selectedBackgroundView
        checkmarkImageView.isHidden = !selected
        titleLabel.textColor = !selected ? UIColor.gray : UIColor.black
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
