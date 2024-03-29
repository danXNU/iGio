//
//  SettingsUserCell.swift
//  SFA
//
//  Created by Daniel Fortesque on 04/01/2019.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit

enum UserState {
    case loggedIn
    case empty
}

class SettingsUserCell: BoldCell {

    var mainTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout)
        label.textColor = Theme.current.cellTitleColor
        return label
    }()
    
    var descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = Theme.current.cellSubtitleColor
        return label
    }()
    
    var labelsStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = UIStackView.Alignment.fill
        stack.distribution = UIStackView.Distribution.fillProportionally
        return stack
    }()
        
    override func prepareForReuse() {
        super.prepareForReuse()
        mainTitleLabel.textColor = Theme.current.cellTitleColor
        descriptionLabel.textColor = Theme.current.cellSubtitleColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        labelsStack.addArrangedSubview(mainTitleLabel)
        labelsStack.addArrangedSubview(descriptionLabel)
        containerView.addSubview(labelsStack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        labelsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        labelsStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        labelsStack.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.75).isActive = true
    }
}
