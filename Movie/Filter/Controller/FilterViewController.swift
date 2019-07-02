//
//  FilterViewController.swift
//  Movie
//
//  Created by A K on 7/2/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    func filter(genres: [Genre])
}

class FilterViewController: UIViewController {

    weak var delegate: FilterViewControllerDelegate?
    
    private var genres = [Genre]()
    private var selectedGenres = [Genre]()

    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
        return cancelBarButtonItem
    }()
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(_:)))
        return doneBarButtonItem
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        setupUI()
        loadGenres()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func setupUI() {
        title = "Filter"
        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: true)
        navigationItem.setRightBarButton(doneBarButtonItem, animated: true)
    }
    
    private func loadGenres() {
        APIService.shared.getMovieGenres { [weak self] (genres, error) in
            if let self = `self` {
                guard let genres = genres else { return }
                self.genres = genres
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - UIKeyboardNotification
    @objc func keyboardWillShow(_ notification: Notification?) {
        if let userInfo = notification?.userInfo {
            let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).size.height
            let contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
            
            tableView.contentInset = contentInset
            tableView.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        let contentInset = UIEdgeInsets.zero
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }
    
    //MARK: - Actions
    @objc private func cancelAction(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneAction(_ sender: UIButton) {
        delegate?.filter(genres: selectedGenres)
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genre = genres[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.reuseIdentifier) as! FilterTableViewCell
        cell.setup(with: genre.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = genres[indexPath.row]
        if selectedGenres.contains(where: { $0.id == genre.id }) {
            selectedGenres.removeAll(where: { $0.id == genre.id })
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectedGenres.append(genre)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
}
