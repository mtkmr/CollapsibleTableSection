//
//  CollapsibleTableSectionViewController.swift
//  CollapsibleTableSection
//
//  Created by Masato Takamura on 2021/09/24.
//

import UIKit

final class CollapsibleTableSectionViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        tableView.register(CollapsibleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.className)
        return tableView
    }()

    private var menuSections: [Section] = [
        Section(
            name: "ユーザー設定",
            rows: [
                Row(name: "メール/パスワード認証"),
                Row(name: "パスワード変更"),
                Row(name: "アカウント削除")
            ]
        ),
        Section(
            name: "このアプリについて",
            rows: [
                Row(name: "シェアする"),
                Row(name: "レビューする"),
                Row(name: "お問い合わせ"),
                Row(name: "利用規約"),
                Row(name: "プライバシーポリシー"),
            ]
        ),
        Section(
            name: "その他",
            rows: [
                Row(name: "＊＊＊＊＊"),
                Row(name: "＊＊＊＊＊"),
                Row(name: "＊＊＊＊＊"),
                Row(name: "＊＊＊＊＊"),
                Row(name: "＊＊＊＊＊")
            ]
        )
    ]

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        ]

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

}

//MARK: - UITableViewDelegate
extension CollapsibleTableSectionViewController: UITableViewDelegate {
    //Cellの設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //Headerの設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.className) as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: CollapsibleTableViewHeader.className)
        header.configure(
            at: section,
            title: menuSections[section].name,
            collapsed: menuSections[section].collapsed
        )
        header.delegate = self
        return header
    }

    //Footerの設定
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer")
        footer?.backgroundColor = .white
        return footer
    }
}

//MARK: - UITableViewDataSource
extension CollapsibleTableSectionViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return menuSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSections[section].collapsed ? 0 : menuSections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuSections[indexPath.section].rows[indexPath.row].name
        return cell
    }

}

//MARK: - CollapsibleTableViewHeaderDelegate
extension CollapsibleTableSectionViewController: CollapsibleTableViewHeaderDelegate {
    ///sectionのcollpsed状態をトグルしてテーブルを更新する
    func toggleSection(_ header: UITableViewHeaderFooterView, section: Int) {
        menuSections[section].collapsed.toggle()
        DispatchQueue.main.async {
            self.tableView.reloadSections(
                NSIndexSet(index: section) as IndexSet,
                with: .automatic
            )
        }
    }

}
