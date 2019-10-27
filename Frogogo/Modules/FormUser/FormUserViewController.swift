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
        static let formHeight: CGFloat = 420
        static let formRoundTop: CGFloat = 40
        static let cellHeight: CGFloat = 70
        static let alertHeight: CGFloat = 186
        static let alertWidth: CGFloat = 305
        static let circleHeight: CGFloat = 62
        static let iconHeight: CGFloat = 50
    }

    private let modalTransition = ModalTransitionDelegate()

    private let formView = UIView().thenUI {
        $0.backgroundColor = UIColor.white
        $0.roundTop(radius: Constants.formRoundTop)
    }

    private let circleView = UIView().thenUI {
        $0.backgroundColor = .clear
        $0.layer.borderColor = Asset.lightGreen.color.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 25
    }

    private let iconImageView = UIImageView().thenUI {
        $0.contentMode = .scaleAspectFit
        $0.image = Asset.emptyIcon4.image
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

    private let visualEffectView = UIVisualEffectView().thenUI {
        $0.alpha = 0
        $0.effect = UIBlurEffect(style: .dark)
    }

    private let alertView = AlertView().prepareForAutoLayout()

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
        configureCircleView()
        configureIconImageView()
        configureExitButton()
        configureActionButton()
        configureTableView()
        completionHandlers()
        configureVisualEffectView()
    }

    private func completionHandlers() {
        viewModel.completionHandler = { [weak self] in
            switch $0 {
            case .incorrectEmail:
                self?.setAlert(title: Localized.Alert.titleError,
                               description: Localized.FormUser.errorEmail)
            case .emptyFields:
                self?.setAlert(title: Localized.Alert.titleError,
                               description: Localized.FormUser.errorEmptyFields)
            }
        }
    }

    private func configureFormView() {
        view.addSubview(formView)
        formView.hideKeyboardWhenTappedAround()
        formView.withoutSafeArea {
            $0.left().right().bottom().height(Constants.formHeight)
        }
    }

    private func configureCircleView() {
        formView.addSubview(circleView)
        circleView.top(4).height(Constants.circleHeight).aspectRatio().centerX()
    }

    private func configureIconImageView() {
        circleView.addSubview(iconImageView)
        iconImageView.centerY().centerX().height(Constants.iconHeight).aspectRatio()
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
        tableView.topAnchor ~ exitButton.bottomAnchor + 10
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

    private func configureVisualEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.hideKeyboardWhenTappedAround()
        visualEffectView.withoutSafeArea { $0.pin() }
    }

    private func setAlert(title: String, description: String) {
        view.addSubview(alertView)
        alertView.width(Constants.alertWidth).height(Constants.alertHeight)
        alertView.centerYAnchor ~ formView.centerYAnchor - 50
        alertView.centerXAnchor ~ formView.centerXAnchor
        alertView.configure(title: title,
                            description: description,
                            titleAction: Localized.Alert.titleActionOk)
        alertView.animationHandler = { [weak self] in
            self?.visualEffectView.alpha = CGFloat($0.rawValue)
        }

        alertView.setAnimationAlert(state: .show)
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
