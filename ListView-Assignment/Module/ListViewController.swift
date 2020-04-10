//
//  ListViewController.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {
    
    var tableView: UITableView!
    
    var dataSource: ResponseModel? {
        didSet {
            DispatchQueue.main.async {
                self.title = self.dataSource?.title
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.showSpinner()
        getListData { (_) in
            self.hideSpinner()
        }
    }
    
    func getListData(completion: ((_ success: Bool)->())? = nil) {
        APIManager.getListData { (result) in
            switch result {
            case .success(let response):
                self.dataSource = response
                completion?(true)
            case .failure(let error):
                print(error)
                completion?(false)
            }
        }
    }

    func setupTableView() {
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(ListCell.self, forCellReuseIdentifier: "ListTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addSubview(self.refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getListData { [weak self] (completed) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.dataSource, let rows = dataSource.rows {
            return rows.count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListCell {
            guard let dataSource = dataSource, let rows = dataSource.rows  else { return cell }
            
            cell.setDataModel(model: rows[indexPath.row])
            cell.selectionStyle = .none
            
            guard let url = rows[indexPath.row].imageHref  else {
                cell.loadImageIfRequired(from: nil)
                return cell
            }
            
            cell.loadImageIfRequired(from: url)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

