//
//  AccountSettingsViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/31.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class AccountSettingsViewController: BaseViewController {

  // MARK: - Defines

  private struct Subject {
    let alert: PublishSubject<RxAlert<Void>> = .init()
  }


  // MARK: - UI Components

  private let closeButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.image = .init(systemName: "xmark")
    configuration.contentInsets.leading = 1.5
    configuration.preferredSymbolConfigurationForImage = .init(pointSize: 13, weight: .medium)

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let tableView: BaseTableView = {
    let view: BaseTableView = .init(frame: .zero, style: .insetGrouped)
    view.register(ChangeProfilePhotoCell.self)
    return view
  }()


  // MARK: - Properties

  private let dataSource: RxTableViewSectionedReloadDataSource<AccountSettingSection> = .init(
    configureCell: { (
      dataSource: TableViewSectionedDataSource<AccountSettingSection>,
      tableView: UITableView,
      indexPath: IndexPath,
      item: AccountSettingSectionItem
    ) -> UITableViewCell in
      switch item {
      case .account:
        let cell: BaseTableViewCell = .init()
        cell.textLabel?.text = "Account"
        return cell

      case .changePassword:
        let cell: BaseTableViewCell = .init()
        cell.textLabel?.text = "Change Password"
        return cell

      case .changeProfilePhoto:
      let cell: ChangeProfilePhotoCell = tableView.dequeue(ChangeProfilePhotoCell.self, for: indexPath)

      if let urlString: String = User.me?.profileImage?.medium,
         let url: URL = .init(string: urlString) {
        cell.configure(url: url)
      }

      return cell

      case .editProfile:
        let cell: BaseTableViewCell = .init()
        cell.textLabel?.text = "Edit Profile"
        return cell
      }
    }
  )

  private let subject: Subject = .init()

  private let viewModel: AccountSettingViewModel


  // MARK: - Initializers

  init(viewModel: AccountSettingViewModel) {
    self.viewModel = viewModel

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .init(red: 28/255, green: 28/255, blue: 28/255, alpha: 1.0)
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.tableView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.tableView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
      make.left.right.bottom.equalToSuperview().inset(1)
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(title: "Settings")
    self.navigationItem.leftBarButtonItem = .init(customView: self.closeButton)
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: AccountSettingViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestSections: self.rx
        .viewDidLoad
        .asObservable()
    ))

    outputs.sections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.subject
      .alert
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    self.closeButton.rx
      .tap
      .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)

    self.tableView.rx
      .modelSelected(AccountSettingSectionItem.self)
      .subscribe(onNext: { [weak self] (item: AccountSettingSectionItem) in
        switch item {
        case .account:
          let alert: RxAlert<Void> = .init(
            actions: [.init(style: .cancel, title: "OK", value: ())],
            message: "Unsplash does not provide an API for closing account.",
            title: nil
          )

          self?.subject.alert.onNext(alert)

        case .changePassword:
          let alert: RxAlert<Void> = .init(
            actions: [.init(style: .cancel, title: "OK", value: ())],
            message: "Unsplash does not provide an API for changing password.",
            title: nil
          )

          self?.subject.alert.onNext(alert)

        case .changeProfilePhoto:
          let alert: RxAlert<Void> = .init(
            actions: [.init(style: .cancel, title: "OK", value: ())],
            message: "Unsplash does not provide an API for changing profile photo.",
            title: nil
          )

          self?.subject.alert.onNext(alert)

        case .editProfile:
          let editProfileViewController: EditProfileViewController = AppAssembler.resolve(
            EditProfileViewController.self
          )

          self?.navigationController?.pushViewController(editProfileViewController, animated: true)
        }
      })
      .disposed(by: self.disposeBag)
  }
}
