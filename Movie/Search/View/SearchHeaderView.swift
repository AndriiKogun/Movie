//
//  SearchHeaderView.swift
//  Movie
//
//  Created by A K on 6/30/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class SearchHeaderView: UIView {

    var completionBlock: ((_ query: String) -> Void)?
    
    func setup(query: String) {
        searchTextField.text = query
    }
    
    func makeFirstResponder()  {
        searchTextField.becomeFirstResponder()
    }
    
    private var searchTask: DispatchWorkItem?

    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = "Search for a movie"
        searchTextField.borderStyle = UITextField.BorderStyle.none
        searchTextField.backgroundColor = UIColor.white
        searchTextField.addTarget(self, action: #selector(textFieldDidChangeAction(_:)), for: .editingChanged)
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.clearButtonMode = .always
        searchTextField.delegate = self
        return searchTextField
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupLayout()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
    }
    
    @objc private func textFieldDidChangeAction(_ sender: UITextField) {
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            if let self = `self` {
                if let completionBlock = self.completionBlock {
                    completionBlock(sender.text ?? "")
                }
            }
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
}

//MARK: - UITextFieldDelegate
extension SearchHeaderView: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let completionBlock = self.completionBlock {
            completionBlock("")
        }
        return true
    }
}

