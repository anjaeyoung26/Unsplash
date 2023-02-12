//
//  AppMenuViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/01.
//

import MessageUI
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class AppMenuViewController: BaseViewController {

  // MARK: - UI Components

  private let doneButton: UIButton = {
    let button: UIButton = .init()
    button.titleLabel?.font = .systemFont(ofSize: 17)
    button.setTitle("Done", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()

  private let tableView: BaseTableView = {
    let view: BaseTableView = .init(frame: .zero, style: .grouped)
    view.register(AppSummaryCell.self)
    return view
  }()


  // MARK: - Properties

  private let dataSource: RxTableViewSectionedReloadDataSource<AppMenuSection> = .init(
    configureCell: { (
      dataSource: TableViewSectionedDataSource<AppMenuSection>,
      tableView: UITableView,
      indexPath: IndexPath,
      item: AppMenuSectionItem
    ) -> UITableViewCell in
    switch item {
    case .summary(let summary):
      let cell: AppSummaryCell = tableView.dequeue(AppSummaryCell.self, for: indexPath)
      cell.configure(summary: summary)
      return cell

    case .recommend:
      let cell: BaseTableViewCell = .init()
      cell.textLabel?.text = "Recommend Unsplash"
      return cell

    case .review:
      let cell: BaseTableViewCell = .init()
      cell.textLabel?.text = "Write a review"
      return cell

    case .feedback:
      let cell: BaseTableViewCell = .init()
      cell.textLabel?.text = "Send us feedback"
      return cell

    case .visit:
      let cell: BaseTableViewCell = .init()
      cell.textLabel?.text = "Visit unsplash.com"
      return cell

    case .license:
      let cell: BaseTableViewCell = .init()
      cell.textLabel?.text = "License"
      return cell
    }
  })

  private let viewModel: AppMenuViewModel


  // MARK: - Initializers

  init(viewModel: AppMenuViewModel) {
    self.viewModel = viewModel

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .init(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.doneButton,
      self.tableView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.doneButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalToSuperview().inset(15)
      make.right.equalToSuperview().inset(20)
    }

    self.tableView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.doneButton.snp.bottom).offset(15)
      make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: AppMenuViewModel.Outputs = self.viewModel.transform(inputs: .init(
      loadSections: self.rx
        .viewDidLoad
        .asObservable()
    ))

    outputs.sections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.doneButton.rx
      .tap
      .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)

    self.tableView.rx
      .modelSelected(AppMenuSectionItem.self)
      .subscribe(onNext: { [weak self] (item: AppMenuSectionItem) in
        switch item {
        case .feedback(let feedback):
          let viewController: MFMailComposeViewController = .init()
          viewController.mailComposeDelegate = self
          viewController.setToRecipients(feedback.recipients)
          viewController.setSubject(feedback.subject)
          self?.present(viewController, animated: true)

        case .recommend(let items):
          let activityViewController: UIActivityViewController = .init(
            activityItems: items,
            applicationActivities: nil
          )
          activityViewController.excludedActivityTypes = [.airDrop, .copyToPasteboard,]
          self?.present(activityViewController, animated: true)

        case .license(let url),
             .review(let url),
             .visit(let url):
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
          }

        case .summary:
          break
        }
      })
      .disposed(by: self.disposeBag)
  }
}


// MARK: - MFMailComposeViewControllerDelegate

extension AppMenuViewController: MFMailComposeViewControllerDelegate {

  func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?
  ) {
    controller.dismiss(animated: true)
  }
}
