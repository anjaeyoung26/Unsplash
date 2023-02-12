//
//  EditProfileViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/06.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class EditProfileViewController: BaseViewController {

  // MARK: - Defines

  fileprivate struct Subject {
    let email: BehaviorSubject<String?> = .init(value: nil)
    let firstName: BehaviorSubject<String?> = .init(value: nil)
    let lastName: BehaviorSubject<String?> = .init(value: nil)
    let location: BehaviorSubject<String?> = .init(value: nil)
    let userName: BehaviorSubject<String?> = .init(value: nil)
    let website: BehaviorSubject<String?> = .init(value: nil)
  }

  // MARK: - UI Components

  private let saveButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.title = "Save"

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let tableView: BaseTableView = {
    let view: BaseTableView = .init(frame: .zero, style: .insetGrouped)
    view.register(TextFieldCell.self)
    return view
  }()


  // MARK: - Properties

  private lazy var dataSource: RxTableViewSectionedReloadDataSource<EditProfileSection> = .init(
    configureCell: { [weak self] (
      dataSource: TableViewSectionedDataSource<EditProfileSection>,
      tableView: UITableView,
      indexPath: IndexPath,
      item: EditProfileSectionItem
    ) -> UITableViewCell in
      guard let self = self else { return .init() }

      let cell: TextFieldCell = tableView.dequeue(
        TextFieldCell.self,
        for: indexPath
      )
      cell.clearButtonMode = .never

      switch item {
      case .email(let email):
        cell.text = email
        cell.placeholder = "Email"
        cell.rx
          .text
          .bind(to: self.subject.email)
          .disposed(by: cell.disposeBag)

      case .firstName(let name):
        cell.text = name
        cell.placeholder = "First name"
        cell.rx
          .text
          .bind(to: self.subject.firstName)
          .disposed(by: cell.disposeBag)

      case .lastName(let name):
        cell.text = name
        cell.placeholder = "Last name"
        cell.rx
          .text
          .bind(to: self.subject.lastName)
          .disposed(by: cell.disposeBag)

      case .location(let location):
        cell.text = location
        cell.placeholder = "Location"
        cell.rx
          .text
          .bind(to: self.subject.location)
          .disposed(by: cell.disposeBag)

      case .userName(let name):
        cell.text = name
        cell.placeholder = "User name"
        cell.rx
          .text
          .bind(to: self.subject.userName)
          .disposed(by: cell.disposeBag)

      case .website(let url):
        cell.text = url
        cell.placeholder = "Website"
        cell.rx
          .text
          .bind(to: self.subject.website)
          .disposed(by: cell.disposeBag)
      }

      return cell
    },
    titleForHeaderInSection: { (
      dataSource: TableViewSectionedDataSource<EditProfileSection>,
      section: Int
    ) -> String? in
      return dataSource.sectionModels[section].title
    }
  )

  private let subject: Subject = .init()

  private let viewModel: EditProfileViewModel


  // MARK: - Initializers

  init(viewModel: EditProfileViewModel) {
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

  override func setComponents() {
    super.setComponents()
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(title: "Edit Profile")
    self.navigationItem.rightBarButtonItem = .init(customView: self.saveButton)
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let updateProfileParameter: Observable<Parameter.UpdateProfile> = self.createUpdateProfileParameter()

    let outputs: EditProfileViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestSections: self.rx
        .viewDidLoad
        .compactMap { _ -> User? in .me },
      updateProfile: self.saveButton.rx
        .tap
        .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
        .withLatestFrom(updateProfileParameter)
    ))

    outputs.isUpdatingProfile
      .drive(self.saveButton.rx.showsActivityIndicator)
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.sections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    outputs.updateProfile
      .drive(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: self.disposeBag)

    self.tableView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func createUpdateProfileParameter() -> Observable<Parameter.UpdateProfile> {
    return .combineLatest(
      self.subject.userName,
      self.subject.firstName,
      self.subject.lastName,
      self.subject.email,
      self.subject.location,
      self.subject.website,
      resultSelector: { (
        userName: String?,
        firstName: String?,
        lastName: String?,
        email: String?,
        location: String?,
        website: String?
      ) -> Parameter.UpdateProfile in
        return .init(
          userName: userName,
          firstName: firstName,
          lastName: lastName,
          email: email,
          location: location,
          url: website
        )
      }
    )
  }
}


// MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 45
  }
}
