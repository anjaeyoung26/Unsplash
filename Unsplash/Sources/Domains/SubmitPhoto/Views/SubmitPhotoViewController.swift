//
//  SubmitPhotoViewController.swift
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


final class SubmitPhotoViewController: BaseViewController {

  // MARK: - Defines

  fileprivate struct Subject {
    let description: BehaviorSubject<String?> = .init(value: nil)
    let location: BehaviorSubject<Location?> = .init(value: nil)
    let showOnProfile: BehaviorSubject<Bool> = .init(value: true)
    let tags: BehaviorSubject<[String]> = .init(value: [])
  }


  // MARK: - UI Components

  private let cancelButton: UIButton = {
    let button: UIButton = .init()
    button.titleLabel?.font = .systemFont(ofSize: 17)
    button.setTitle("Cancel", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()

  private let submitButton: UIButton = {
    let button: UIButton = .init()
    button.titleLabel?.font = .systemFont(ofSize: 17)
    button.setTitle("Submit", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()

  private let tableView: BaseTableView = {
    let view: BaseTableView = .init(frame: .zero, style: .grouped)
    view.tintColor = .white
    view.isScrollEnabled = false
    view.isFittingContent = true
    view.endEditingWhenTouchesBegan = true
    view.register(TextViewCell.self)
    view.register(TagTextFieldCell.self)
    view.register(ObservableSwitchCell.self)
    view.register(BindableInputTextFieldCell.self)
    return view
  }()

  private let scrollView: UIScrollView = {
    let view: UIScrollView = .init()
    view.bounces = false
    view.showsVerticalScrollIndicator = false
    return view
  }()

  private let containerView: UIView = {
    let view: UIView = .init()
    return view
  }()

  private let photoImageView: BaseImageView = .init(image: nil)


  // MARK: - Properties

  private lazy var dataSource: RxTableViewSectionedReloadDataSource<SubmitPhotoSection> = .init(
    configureCell: { [weak self] (
      dataSource: TableViewSectionedDataSource<SubmitPhotoSection>,
      tableView: UITableView,
      indexPath: IndexPath,
      item: SubmitPhotoSectionItem
    ) -> UITableViewCell in
      guard let self = self else { return .init() }

      let backgroundColor: UIColor = .init(
        red: 44/255,
        green: 44/255,
        blue: 47/255,
        alpha: 1.0
      )

      switch item {
      case .description:
        let cell: TextViewCell = tableView.dequeue(TextViewCell.self, for: indexPath)
        cell.placeholder = "Add Description"
        cell.backgroundColor = backgroundColor
        cell.rx
          .text
          .bind(to: self.subject.description)
          .disposed(by: cell.disposeBag)
        
        return cell

      case .location:
        let cell: BindableInputTextFieldCell = tableView.dequeue(
          BindableInputTextFieldCell.self,
          for: indexPath
        )
        cell.placeholder = "Add Location"
        cell.backgroundColor = backgroundColor
        
        cell.rx
          .didClearText
          .subscribe(onNext: { self.subject.location.onNext(nil) })
          .disposed(by: cell.disposeBag)

        cell.rx
          .didBeginInput
          .withLatestFrom(self.subject.location)
          .bind(to: self.rx.presentEditLocation)
          .disposed(by: cell.disposeBag)

        self.subject.location
          .map { (location: Location?) -> String in
            var texts: [String] = []

            if let name: String = location?.name {
              texts.append(name)
            }

            if let city: String = location?.city {
              texts.append(city)
            }

            if let country: String = location?.country {
              texts.append(country)
            }

            return texts.joined(separator: ", ")
          }
          .bind(to: cell.rx.text)
          .disposed(by: self.disposeBag)

        return cell

      case .tags:
        let cell: TagTextFieldCell = tableView.dequeue(TagTextFieldCell.self, for: indexPath)
        cell.placeholder = "Add Tags"
        cell.backgroundColor = backgroundColor

        cell.rx
          .didChangeTags
          .bind(to: self.subject.tags)
          .disposed(by: cell.disposeBag)

        cell.rx
          .didChangeHeight
          .observeOn(MainScheduler.asyncInstance)
          .subscribe(onNext: { [weak self] (height: CGFloat) in
            tableView.beginUpdates()
            self?.tagCellHeight = height
            tableView.endUpdates()
          })
          .disposed(by: cell.disposeBag)

        return cell

      case .exifMake(let make):
        let cell: BaseTableViewCell = .init(style: .value1, reuseIdentifier: "")

        var contentConfiguration: UIListContentConfiguration = cell.exifContentConfiguration()
        contentConfiguration.text = "Make"
        contentConfiguration.secondaryText = make
        cell.contentConfiguration = contentConfiguration

        return cell

      case .exifModel(let model):
        let cell: BaseTableViewCell = .init(style: .value1, reuseIdentifier: "")

        var contentConfiguration: UIListContentConfiguration = cell.exifContentConfiguration()
        contentConfiguration.text = "Model"
        contentConfiguration.secondaryText = model
        cell.contentConfiguration = contentConfiguration

        return cell

      case .exifFocalLength(let length):
        let cell: BaseTableViewCell = .init(style: .value1, reuseIdentifier: "")

        var contentConfiguration: UIListContentConfiguration = cell.exifContentConfiguration()
        contentConfiguration.text = "Focal Length (mm)"
        contentConfiguration.secondaryText = length
        cell.contentConfiguration = contentConfiguration

        return cell

      case .exifAperture(let aperture):
        let cell: BaseTableViewCell = .init(style: .value1, reuseIdentifier: "")

        var contentConfiguration: UIListContentConfiguration = cell.exifContentConfiguration()
        contentConfiguration.text = "Aperture (f)"
        contentConfiguration.secondaryText = aperture
        cell.contentConfiguration = contentConfiguration

        return cell

      case .exifShutterSpeed(let speed):
        let cell: BaseTableViewCell = .init(style: .value1, reuseIdentifier: "")

        var contentConfiguration: UIListContentConfiguration = cell.exifContentConfiguration()
        contentConfiguration.text = "Shutter Speed (s)"
        contentConfiguration.secondaryText = speed
        cell.contentConfiguration = contentConfiguration

        return cell

      case .exifISO(let iso):
        let cell: BaseTableViewCell = .init(style: .value1, reuseIdentifier: "")

        var contentConfiguration: UIListContentConfiguration = cell.exifContentConfiguration()
        contentConfiguration.text = "ISO"
        contentConfiguration.secondaryText = iso
        cell.contentConfiguration = contentConfiguration

        return cell

      case .showOnProfile:
        let cell: ObservableSwitchCell = .init()
        cell.textLabel?.text = "Show on Profile"

        let observer: AnyObserver<Bool> = self.subject.showOnProfile.asObserver()
        cell.bind(observer: observer)
        
        return cell
      }
    },
    titleForHeaderInSection: { (
      dataSource: TableViewSectionedDataSource<SubmitPhotoSection>,
      section: Int
    ) -> String? in
      return dataSource.sectionModels[section].title
    }
  )

  private var tagCellHeight: CGFloat = UITableView.automaticDimension

  fileprivate let subject: Subject = .init()

  fileprivate let sheetTransitionController: SheetTransitioningController = .init()

  fileprivate var submitProgressViewController: SubmitProgressViewController?

  private let viewModel: SubmitPhotoViewModel

  private let info: [UIImagePickerController.InfoKey: AnyObject]


  // MARK: - Initializers

  init(viewModel: SubmitPhotoViewModel, info: [UIImagePickerController.InfoKey: AnyObject]) {
    self.viewModel = viewModel
    self.info = info

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
      self.cancelButton,
      self.submitButton,
      self.scrollView.with(
        self.containerView.with(
          self.photoImageView,
          self.tableView
        )
      )
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.cancelButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalToSuperview().inset(15)
      make.left.equalToSuperview().inset(20)
    }

    self.submitButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalToSuperview().inset(15)
      make.right.equalToSuperview().inset(20)
    }

    self.scrollView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.submitButton.snp.bottom).offset(10)
      make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.containerView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
      make.width.equalTo(self.scrollView.frameLayoutGuide)
    }

    self.photoImageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalToSuperview()

      if let image: UIImage = self.info[.originalImage] as? UIImage {
        let height: CGFloat = (self.view.frame.width * image.size.height) / image.size.width
        make.height.equalTo(height)
      }
    }

    self.tableView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.photoImageView.snp.bottom).offset(10)
      make.left.right.bottom.equalToSuperview()
    }
  }

  override func setComponents() {
    super.setComponents()

    self.photoImageView.image = self.info[.originalImage] as? UIImage
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let uploadPhotoParameter: Observable<Parameter.UploadPhoto> = self.createUploadPhotoParameter()

    let outputs: SubmitPhotoViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestSections: self.rx
        .viewDidLoad
        .compactMap { [weak self] _ -> PHAsset? in return self?.info[.phAsset] as? PHAsset },
      uploadPhoto: self.submitButton.rx
        .tap
        .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
        .withLatestFrom(uploadPhotoParameter )
    ))

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.sections
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    outputs.uploadComplete
      .do(onNext: { [weak self] _ in
        self?.submitProgressViewController?.dismiss(animated: true)
        self?.submitProgressViewController = nil
        self?.dismiss(animated: true)
      })
      .drive(onNext: { (photo: Photo) in
        WindowRouter.tabBarController?.presentThanksSubmit(for: photo)
      })
      .disposed(by: self.disposeBag)

    outputs.uploadProgress
      .drive(self.rx.presentSubmitProgress)
      .disposed(by: self.disposeBag)

    self.cancelButton.rx
      .tap
      .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)

    self.tableView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func createUploadPhotoParameter() -> Observable<Parameter.UploadPhoto> {
    return .combineLatest(
      self.subject.description,
      self.subject.showOnProfile,
      self.subject.tags,
      self.subject.location,
      resultSelector: { (
        description: String?,
        showOnProfile: Bool,
        tags: [String],
        location: Location?
      ) -> Parameter.UploadPhoto in
        return .init(
          description: description,
          showOnProfile: showOnProfile,
          tags: tags,
          location: location
        )
      }
    )
  }
}


// MARK: - UITableViewDelegate

extension SubmitPhotoViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section: SubmitPhotoSection = self.dataSource.sectionModels[indexPath.section]
    let item: SubmitPhotoSectionItem = section.items[indexPath.row]

    switch item {
    case .exifMake,
         .exifModel,
         .exifFocalLength,
         .exifAperture,
         .exifShutterSpeed,
         .exifISO,
         .showOnProfile:
      return UITableView.automaticDimension
    case .description:
      return 110
    case .location:
      return 45
    case .tags:
      return self.tagCellHeight
    }
  }
}


// MARK: - Reactive

extension Reactive where Base: SubmitPhotoViewController {

  var presentEditLocation: Binder<Location?> {
    return Binder(self.base) { (base: SubmitPhotoViewController, priorLocation: Location?) in
      let viewController: EditLocationViewController = AppAssembler.resolve(
        EditLocationViewController.self,
        argument: priorLocation
      )
      let navigationController: UINavigationController = .init(rootViewController: viewController)

      viewController.rx
        .didSelectLocation
        .do(onNext: { [weak navigationController] _ in
          navigationController?.dismiss(animated: true)
        })
        .bind(to: base.subject.location)
        .disposed(by: viewController.disposeBag)

      base.present(navigationController, animated: true)
    }
  }

  var presentSubmitProgress: Binder<Double> {
    return Binder(self.base) { (base: SubmitPhotoViewController, progress: Double) in
      if let viewController: SubmitProgressViewController = base.submitProgressViewController {
        viewController.rx.progress.onNext(progress)
      } else {
        let viewController: SubmitProgressViewController = AppAssembler.resolve(
          SubmitProgressViewController.self
        )
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = base.sheetTransitionController

        base.submitProgressViewController = viewController
        base.present(viewController, animated: true)
      }
    }
  }
}


// MARK: - BaseTableViewCell Extension (Private)

private extension BaseTableViewCell {

  func exifContentConfiguration() -> UIListContentConfiguration {
    var contentConfiguration: UIListContentConfiguration = self.defaultContentConfiguration()
    contentConfiguration.textProperties.font = .systemFont(ofSize: 18)
    contentConfiguration.textProperties.color = .white
    contentConfiguration.secondaryTextProperties.font = .systemFont(ofSize: 18)
    contentConfiguration.secondaryTextProperties.color = .white
    return contentConfiguration
  }
}
