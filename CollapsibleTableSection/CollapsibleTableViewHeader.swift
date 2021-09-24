//
//  CollapsibleTableViewHeader.swift
//  CollapsibleTableSection
//
//  Created by Masato Takamura on 2021/09/24.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate: AnyObject {
    func toggleSection(_ header: UITableViewHeaderFooterView, section: Int)
}

final class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    static var className: String {
        String(describing: CollapsibleTableViewHeader.self)
    }

    weak var delegate: CollapsibleTableViewHeaderDelegate?

    var section: Int = 0

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .clear
        return label
    }()

    private lazy var arrowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .clear
        label.text = ">"
        label.textAlignment = .center
        return label
    }()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTapHeader(_:))
        ))

        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowLabel)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///オートレイアウトによる制約であることを明示
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    //オートレイアウトを記述
    override func updateConstraints() {
        //titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        //arrowLabel
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowLabel.widthAnchor.constraint(equalTo: arrowLabel.heightAnchor),
            arrowLabel.widthAnchor.constraint(equalToConstant: 28),
            arrowLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        super.updateConstraints()
    }

    ///configureメソッド
    func configure(at section: Int, title: String, collapsed: Bool) {
        self.section = section
        titleLabel.text = title
        arrowLabel.rotate(collapsed ? 0 : .pi / 2)
    }

}

//MARK: - CollapsibleTableViewHeader
@objc private extension CollapsibleTableViewHeader {
    ///ヘッダーがタップされたときの処理
    func didTapHeader(_ gestureRecognizer: UIGestureRecognizer) {
        guard let header = gestureRecognizer.view as? CollapsibleTableViewHeader else { return }
        delegate?.toggleSection(self, section: header.section)
    }
}
