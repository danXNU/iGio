//
//  TeenStarEditEntryView.swift
//  SFA
//
//  Created by Dani Tox on 03/01/19.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit

class TeenStarEditEntryView: UIView {

    var tableView : UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.backgroundColor = Theme.current.tableViewBackground
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
