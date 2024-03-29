//
//  ListUsersViewController.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/25/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ListUsersViewController: ParentViewController {

    private enum Constants {
        static let headerHeight: CGFloat = 170
        static let cellHeight: CGFloat = 85
        static let bottomGradientViewHeight: CGFloat = 100
        static let alertHeight: CGFloat = 186
        static let alertWidth: CGFloat = 305
    }

    override var navigationBarHidesShadow: Bool {
        return true
    }

    private let headerImageView = UIImageView().thenUI {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
        $0.image = Asset.header.image
    }

    private let bottomGradientView = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }

    private let bottomGradientLayer = CAGradientLayer().then {
        let colors = [Asset.blackOpacity.color.cgColor, Asset.darkGreenOpacity.color.cgColor]
        $0.setupGradient(start: .topCenter, end: .bottomCenter, colors: colors)
    }

    private let tableView = UITableView(frame: .zero, style: .plain).thenUI {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = Constants.cellHeight
        $0.register(UserTableViewCell.self)
    }

    private let addButton = CircleButton(color: Asset.darkGreen.color).thenUI {
        $0.setImage(image: Asset.add.image)
        $0.layer.setupShadow(radius: 5, opacity: 0.2, height: 3)
    }

    private let loadingView = LoadingView().thenUI {
        $0.color = Asset.lightGreen.color
        $0.lineWidth = 4
        $0.isHidden = true
    }

    private let emptyLabel = UILabel().thenUI {
        $0.text = Localized.ListUsers.emptyTitle
        $0.textColor = Asset.lightPinkOpacity.color
        $0.textAlignment = .center
        $0.font = UIFont.system(.regular, size: 26)
        $0.isHidden = true
    }

    private let visualEffectView = UIVisualEffectView().thenUI {
        $0.alpha = 0
        $0.effect = UIBlurEffect(style: .dark)
    }

    private let alertView = AlertView().prepareForAutoLayout()

    deinit {
      tableView.removeParticlePullToRefresh()
    }

    var viewModel: ListUsersViewModelProtocol

    init(viewModel: ListUsersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.white.color
        title = Localized.ListUsers.title
        configureHeaderImageView()
        configureTableView()
        configurePullToRefresh()
        configureAddButton()
        configureBottomGradientView()
        completionHandlers()
        configureEmptyLabel()
        configureVisualEffectView()
        configureLoadingView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoadingView(isShow: true)
        viewModel.requestGetUsers()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomGradientLayer.frame = bottomGradientView.frame
        bottomGradientLayer.frame.origin.y = 0
    }

    private func configureBottomGradientView() {
        view.addSubview(bottomGradientView)
        bottomGradientView.withoutSafeArea {
            $0.left().right().bottom().height(Constants.bottomGradientViewHeight)
        }
        bottomGradientView.layer.addSublayer(bottomGradientLayer)
    }

    private func configureHeaderImageView() {
        view.addSubview(headerImageView)
        headerImageView.withoutSafeArea {
            $0.top().left().right().height(Constants.headerHeight)
        }
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.withoutSafeArea {
            $0.left().right().bottom()
            $0.topAnchor ~ headerImageView.bottomAnchor
        }
    }

    private func configurePullToRefresh() {
        tableView.addParticlePullToRefresh(color: Asset.lightGreen.color) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.viewModel.requestGetUsers()
            }
        }
    }

    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.right(30).bottom(30).height(50).aspectRatio()

        addButton.addAction(for: .touchUpInside) { [weak self] _ in
            self?.addButton.pulsate()

            let vc = ViewControllerAssembly.resolve(type: .formUser) {
                [weak self] in self?.setupLoadingView(isShow: true)
                self?.viewModel.requestGetUsers()
            }

            self?.present(vc, animated: true, completion: nil)
        }
    }

    private func configureLoadingView() {
        view.addSubview(loadingView)
        loadingView.height(60).aspectRatio().centerX().centerY(-20)
    }

    private func configureEmptyLabel() {
        view.addSubview(emptyLabel)
        emptyLabel.centerY(-25).left(16).right(16).height(30)
    }

    private func configureVisualEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.hideKeyboardWhenTappedAround()
        visualEffectView.withoutSafeArea { $0.pin() }
    }

    private func setAlert(with model: AlertModel) {
        view.addSubview(alertView)
        alertView.centerY(-20).centerX()
        alertView.width(Constants.alertWidth).height(Constants.alertHeight)

        alertView.configure(with: model)

        alertView.animationHandler = { [weak self] in
            self?.visualEffectView.alpha = CGFloat($0.rawValue)
        }

        alertView.setAnimationAlert(state: .show)
    }

    private func completionHandlers() {
        viewModel.completionHandler = { [weak self] in
            self?.setupLoadingView(isShow: false)
            switch $0 {
            case .update:
                self?.tableView.particlePullToRefresh?.endRefreshing()
                self?.tableView.reloadWithAnimationFadeInTop()
            case .error:
                self?.setAlert(with: AlertModel.somethingWentWrong)
            }

            self?.emptyLabel.isHidden = self?.viewModel.users?.isEmpty == false
        }
    }

    private func setupLoadingView(isShow: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShow ?
                self.loadingView.startAnimating() :
                self.loadingView.stopAnimating()
        }
    }
}

extension ListUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(for: indexPath) as UserTableViewCell).then {
            $0.configure(with: viewModel.users?[indexPath.row])
        }
    }
}

extension ListUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = ViewControllerAssembly.resolve(type: .formUser) {
            [weak self] in self?.setupLoadingView(isShow: true)
            self?.viewModel.requestGetUsers()
        }

        if let formUserVC = vc as? FormUserViewController {
            formUserVC.viewModel.user = self.viewModel.users?[indexPath.row]

            formUserVC.viewModel.callBackSuccess = { [weak self] in
                self?.setupLoadingView(isShow: true)
                self?.viewModel.requestGetUsers()
            }
        }

        present(vc, animated: true, completion: nil)
    }
}
