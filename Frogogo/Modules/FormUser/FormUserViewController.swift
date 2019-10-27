//
//  FormUserViewController.swift
//  Frogogo
//
//  Created by Andrey on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class FormUserViewController: ParentViewController {

    private enum Constants {
        static let formRoundTop: CGFloat = 40
        static let cellHeight: CGFloat = 70
    }

    private let modalTransition = ModalTransitionDelegate()

    private let formView = UIView().thenUI {
        $0.backgroundColor = UIColor.white
        $0.roundTop(radius: Constants.formRoundTop)
    }

    private let exitButton = CircleButton(color: Asset.darkGreen.color).thenUI {
        $0.setImage(image: Asset.exit.image)
        $0.layer.setupShadow(radius: 5, opacity: 0.2, height: 3)
    }

    private let actionButton = UIButton().thenUI {
        $0.backgroundColor = Asset.darkGreen.color
        $0.layer.cornerRadius = 20
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
        $0.isScrollEnabled = false
    }

    var viewModel: FormUserViewModelProtocol

    init(viewModel: FormUserViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupModalTransitionDelegate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFormView()
        configureExitButton()
        configureActionButton()
        configureTableView()
        completionHandlers()
    }

    private func completionHandlers() {
        viewModel.completionHandler = { [weak self] in
            self?.actionButton.isEnabled = $0
        }
    }

    private func configureFormView() {
        view.addSubview(formView)
        formView.hideKeyboard()
        formView.withoutSafeArea {
            $0.left().right().bottom().height(410)
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
        tableView.bottomAnchor ~ actionButton.topAnchor
    }

    private func configureActionButton() {
        formView.addSubview(actionButton)
        actionButton.bottom().left(16).right(16).bottom(10).height(50)
        actionButton.setTitle(Localized.FormUser.Title.add, for: .normal)

        actionButton.addAction(for: .touchUpInside) { [weak self] _ in
            self?.actionButton.pulsate()
            self?.viewModel.addedNewUser()
        }
    }

    private func setupModalTransitionDelegate() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = modalTransition
    }
}

extension FormUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(for: indexPath) as FormTableViewCell).then {
            $0.configure(with: viewModel.items[indexPath.row], delegate: self)
        }
    }
}

extension FormUserViewController: FormDelegate {
    func moveView(keyboardHeight: CGFloat, isShow: Bool) {
        let distance = (formView.frame.height - actionButton.frame.origin.y - actionButton.frame.height)
        let distanceFromeKeyboard = -keyboardHeight + distance / 2
        view.frame.origin.y = isShow ? distanceFromeKeyboard : 0
    }
}
