//
//  SubmitSheetViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/04.
//

import Photos
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class SubmitSheetViewController: BaseViewController {

  // MARK: - UI Components

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(20)
    label.adjustsFontSizeToFitWidth = true
    return label
  }()

  private let dismissButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(.init(named: "dismiss_icon"), for: .normal)
    return button
  }()

  private let separatorView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .lightGray.withAlphaComponent(0.1)
    return view
  }()

  private let aboutTitleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(16)
    label.text = "About"
    return label
  }()

  private let aboutDescriptionLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 12, weight: .medium)
    label.textColor = .lightGray
    label.numberOfLines = 0
    return label
  }()

  private let submissionLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(16)
    label.text = "Submissions from the community"
    return label
  }()

  private let submitButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .white
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    button.setTitleColor(.black, for: .normal)
    return button
  }()

  private let collectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 8

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.isScrollEnabled = false
    view.register(PhotoCell.self)
    return view
  }()


  // MARK: - Properties

  private let dataSource: RxCollectionViewSectionedReloadDataSource<PhotoSection> = .init(
    configureCell: { (
      dataSource: CollectionViewSectionedDataSource<PhotoSection>,
      collectionView: UICollectionView,
      indexPath: IndexPath,
      item: Photo
    ) -> UICollectionViewCell in
      let cell: PhotoCell = collectionView.dequeue(PhotoCell.self, for: indexPath)
      cell.configure(photo: item)
      cell.cornerRadius = 2
      return cell
    }
  )

  private let viewModel: SubmitSheetViewModel

  private let topic: Topic


  // MARK: - Initializers

  init(viewModel: SubmitSheetViewModel, topic: Topic) {
    self.viewModel = viewModel
    self.topic = topic

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.titleLabel,
      self.dismissButton,
      self.separatorView,
      self.aboutTitleLabel,
      self.aboutDescriptionLabel,
      self.submissionLabel,
      self.collectionView,
      self.submitButton
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalToSuperview().inset(30)
      make.left.equalToSuperview().inset(20)
      make.right.equalTo(self.dismissButton.snp.left).offset(-15)
    }

    self.dismissButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerY.equalTo(self.titleLabel)
      make.right.equalToSuperview().inset(10)
      make.size.equalTo(45)
    }

    self.separatorView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
      make.left.right.equalToSuperview()
      make.height.equalTo(2)
    }

    self.aboutTitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.separatorView.snp.bottom).offset(30)
      make.left.equalToSuperview().inset(20)
    }

    self.aboutDescriptionLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.aboutTitleLabel.snp.bottom).offset(10)
      make.left.right.equalToSuperview().inset(20)
    }

    self.submissionLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.aboutDescriptionLabel.snp.bottom).offset(30)
      make.left.right.equalToSuperview().inset(20)
    }

    self.collectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.submissionLabel.snp.bottom).offset(15)
      make.left.right.equalToSuperview().inset(20)
      make.height.equalTo(90)
    }

    self.submitButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.collectionView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(20)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
      make.height.equalTo(45)
    }
  }

  override func setComponents() {
    super.setComponents()

    self.titleLabel.text = self.topic.title
    self.aboutDescriptionLabel.text = self.topic.description
      .trimmingCharacters(in: .whitespacesAndNewlines)

    let submitTitle = "Submit to \(self.topic.title)"
    let submitAttributedString: NSMutableAttributedString = .init(string: submitTitle)
    submitAttributedString.addAttribute(
      .font,
      value: UIFont.pretendard.bold(16),
      range: NSString(string: submitTitle).range(of: self.topic.title)
    )
    self.submitButton.setAttributedTitle(submitAttributedString, for: .normal)
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: SubmitSheetViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestTopicPhotos: self.rx
        .viewDidLoad
        .compactMap { [weak self] _ -> String? in return self?.topic.id },
      submitPhoto: self.submitButton.rx
        .tap
        .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
    ))

    outputs.openSetting
      .drive(self.rx.openSetting)
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.presentNotAuthorizedAlert
      .drive(self.rx.presentObservableBooleanAlert)
      .disposed(by: self.disposeBag)

    outputs.presentImagePicker
      .observeOn(MainScheduler.instance)
      .flatMapLatest { [weak self] _ -> Observable<[UIImagePickerController.InfoKey: AnyObject]> in
        return self?.rx.presentImagePicker ?? .empty()
      }
      .bind(to: self.rx.presentSubmitPhoto)
      .disposed(by: self.disposeBag)

    outputs.sections
      .drive(self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)

    self.dismissButton.rx
      .tap
      .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension SubmitSheetViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let numberOfCellsPerRow: CGFloat = 4
    let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    let space: CGFloat = (flowLayout.minimumInteritemSpacing * (numberOfCellsPerRow - 1))
      + flowLayout.sectionInset.right
      + flowLayout.sectionInset.left
    let width: CGFloat = (collectionView.bounds.width - space) / numberOfCellsPerRow
    return .init(width: width, height: width)
  }
}


// MARK: - Reactive

extension Reactive where Base: SubmitSheetViewController {

  var openSetting: Binder<Void> {
    return Binder(self.base) { (base: SubmitSheetViewController, _) in
      if let url: URL = .init(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
  }

  var presentSubmitPhoto: Binder<[UIImagePickerController.InfoKey: AnyObject]> {
    return Binder(self.base) { (
      base: SubmitSheetViewController,
      info: [UIImagePickerController.InfoKey: AnyObject]
    ) in
      let viewController: SubmitPhotoViewController = AppAssembler.resolve(
        SubmitPhotoViewController.self,
        argument: info
      )

      base.presentedViewController?.present(viewController, animated: true)
    }
  }
}
