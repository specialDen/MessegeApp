//
//  ActiveChatsTableViewCell.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 13.09.2021.
//

import UIKit
import SnapKit

class ActiveChatsTableViewCell: UITableViewCell {
    
    
    let nameLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .red
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "njfjejfejfjef in"
        return label
    }()
    let lastChatLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.textColor = .red
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "njfjejfejfjef in"
        return label
    }()
    let lastChatDateLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.textColor = .blue
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = " date"
        return label
    }()
    private lazy var stackView: UIStackView = {
        [nameLabel, messageStackView].toStackView(orientation: .vertical, distribution: .fillEqually, spacing: 5.0)
    }()
    private lazy var messageStackView: UIStackView = {
        [lastChatLabel, lastChatDateLabel].toStackView(orientation: .horizontal, distribution: .fillProportionally, spacing: 2.0)
    }()
    
    let friendImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "icon")
        return imageView
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(friendImage)
        contentView.addSubview(stackView)
        
    }
    private func setConstraints(){
        stackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(90)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        friendImage.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
//            make.bottom.equalToSuperview().offset(-20)
//            make.right.equalToSuperview().offset(-100)
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
            
        }
    }
    

}


public extension Array where Element == UIView {
    func toStackView(orientation: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .fill, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: self)
        stackView.axis = orientation
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
}
extension UITableViewCell {
    public static var reuseIdentifier: String {
        String(describing: self)
    }
}
