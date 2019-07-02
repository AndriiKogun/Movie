//
//  FooterView.swift
//  Movie
//
//  Created by A K on 7/3/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {

    func startAnimate() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimate() {
        activityIndicator.stopAnimating()
    }
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
