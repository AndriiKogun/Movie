//
//  SearchViewController.swift
//  TheMovie
//
//  Created by Andrii on 6/28/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func search(query: String)
    func show(movie: Movie)
}

class SearchViewController: UIViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    
    private var suggestedMovies = [Movie]()
    private var query = ""
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
        return cancelBarButtonItem
    }()
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(_:)))
        return doneBarButtonItem
    }()
    
    private lazy var headerView: SearchHeaderView = {
        let headerView = SearchHeaderView()
        headerView.setup(query: query)
        headerView.completionBlock = { [weak self] (query) in
            if let self = `self` {
                self.query = query
                self.loadSuggestion(query: query)
            }
        }
        return headerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: SearchSuggestionTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        setupUI()
        addObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView.makeFirstResponder()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
        title = "Search"
        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: true)
        navigationItem.setRightBarButton(doneBarButtonItem, animated: true)
    }
    
    private func loadSuggestion(query: String) {
        if query.isEmpty {
            suggestedMovies = []
            tableView.reloadData()
        } else {
            APIService.shared.getFilteredMovies(query: query, page: 1) { [weak self] (page, error) in
                if let self = `self` {
                    guard let page = page else { return }
                    self.suggestedMovies = page.movies
                    self.tableView.reloadData()
                    DispatchQueue.main.async {
                        if !page.movies.isEmpty {
                            let indexPath = IndexPath(row: 0, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                    }
                }
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
        delegate?.search(query: query)
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let suggestion = suggestedMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchSuggestionTableViewCell.reuseIdentifier) as! SearchSuggestionTableViewCell
        cell.setup(with: suggestion.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = suggestedMovies[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.show(movie: movie)
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
