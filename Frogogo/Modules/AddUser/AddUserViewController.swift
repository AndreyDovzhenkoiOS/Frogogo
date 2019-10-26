//
//  AddUserViewController.swift
//  Frogogo
//
//  Created by Andrey on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class AddUserViewController: UIViewController {

    private enum Constants {
        static let cellHeight: CGFloat = 70
    }

    private let modalTransition = ModalTransitionDelegate()

    private let formView = UIView().thenUI {
        $0.backgroundColor = UIColor.white
        $0.roundTop(radius: 40)
    }

    private let exitButton = CircleButton(color: Asset.darkGreen.color).thenUI {
        $0.setImage(image: Asset.exit.image)
        $0.layer.setupShadow(radius: 5, opacity: 0.2, height: 3)
    }

    private let stackView = UIStackView().thenUI {
        $0.axis = .vertical
        $0.distribution = .fill
    }

    private let tableView = UITableView(frame: .zero, style: .plain).thenUI {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = Constants.cellHeight
        $0.register(FormTableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFormView()
        configureExitButton()
        configureTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupModalTransitionDelegate()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupModalTransitionDelegate()
    }

    private func configureFormView() {
        view.addSubview(formView)
        formView.withoutSafeArea {
            $0.left().right().bottom().height(500)
        }
    }

    private func configureExitButton() {
        formView.addSubview(exitButton)
        exitButton.right(20).top(16).height(40).aspectRatio()

        exitButton.addAction(for: .touchUpInside) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    private func configureTableView() {
        tableView.dataSource = self

        formView.addSubview(tableView)
        tableView.left(20).right(20).bottom()
        tableView.topAnchor ~ exitButton.bottomAnchor + 8
    }

    private func setupModalTransitionDelegate() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = modalTransition
    }
}

extension AddUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(for: indexPath) as FormTableViewCell).then {
            $0.configure()
        }
    }
}
