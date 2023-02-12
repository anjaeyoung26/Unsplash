//
//  InfoPhotoViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/14.
//

import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class InfoPhotoViewController: BaseViewController {

  // MARK: - UI Components

  private let descriptionLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 13)
    label.numberOfLines = 0
    return label
  }()

  private let separatorView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .lightGray.withAlphaComponent(0.2)
    return view
  }()

  private let closeButton: UIButton = {
    let button: UIButton = .init()
    button.titleLabel?.font = .systemFont(ofSize: 17)
    button.setTitle("Close", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()

  private let cameraLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 15)
    label.text = "Camera"
    return label
  }()

  private let collectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.minimumLineSpacing = 15
    layout.minimumInteritemSpacing = 0

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.register(SubContentCell.self)
    return view
  }()


  // MARK: - Properties

  private let dataSource: RxCollectionViewSectionedReloadDataSource<InfoPhotoSection> = .init(
    configureCell: { (
      dataSource: CollectionViewSectionedDataSource<InfoPhotoSection>,
      collectionView: UICollectionView,
      indexPath: IndexPath,
      item: InfoPhotoSectionItem
    ) -> UICollectionViewCell in
      switch item {
      case .exifMake(let make):
        let cell: SubContentCell = collectionView.dequeue(SubContentCell.self, for: indexPath)
        cell.configure(title: "Make", content: make)
        return cell

      case .exifModel(let model):
        let cell: SubContentCell = collectionView.dequeue(SubContentCell.self, for: indexPath)
        cell.configure(title: "Model", content: model)
        return cell

      case .exifFocalLength(let length):
        let cell: SubContentCell = collectionView.dequeue(SubContentCell.self, for: indexPath)
        cell.configure(title: "Focal Length (mm)", content: length)
        return cell

      case .exifAperture(let aperture):
        let cell: SubContentCell = collectionView.dequeue(SubContentCell.self, for: indexPath)
        cell.configure(title: "Aperture (f)", content: aperture)
        return cell

      case .exifShutterSpeed(let speed):
        let cell: SubContentCell = collectionView.dequeue(SubContentCell.self, for: indexPath)
        cell.configure(title: "Shutter Speed (s)", content: speed)
        return cell

      case .exifISO(let iso):
        let cell: SubContentCell = collectionView.dequeue(SubContentCell.self, for: indexPath)
        cell.configure(title: "ISO", content: iso)
        return cell

      case .dimensions(let width, let height):
        let cell: SubContentCell = collectionView.dequeue(SubContentCell.self, for: indexPath)
        cell.configure(title: "Dimensions", content: "\(width) x \(height)")
        return cell

      case .publishedAt(let publishedAt):
        let cell: SubContentCell = collectionView.dequeue(SubContentCell.self, for: indexPath)
        cell.configure(title: "Published", content: publishedAt)
        return cell
      }
    }
  )

  private let viewModel: InfoPhotoViewModel

  private let photo: Photo


  // MARK: - Initializers

  init(viewModel: InfoPhotoViewModel, photo: Photo) {
    self.viewModel = viewModel
    self.photo = photo

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .systemBackground
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.descriptionLabel,
      self.separatorView,
      self.cameraLabel,
      self.collectionView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.descriptionLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
      make.left.right.equalToSuperview().inset(15)
    }

    self.separatorView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.descriptionLabel.snp.bottom).offset(25)
      make.left.right.equalToSuperview().inset(15)
      make.height.equalTo(0.5)
    }

    self.cameraLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.equalToSuperview().inset(15)

      if self.photo.description == nil {
        make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
      } else {
        make.top.equalTo(self.separatorView.snp.bottom).offset(25)
      }
    }

    self.collectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.cameraLabel.snp.bottom).offset(15)
      make.left.right.bottom.equalToSuperview().inset(15)
    }
  }

  override func setComponents() {
    super.setComponents()

    self.descriptionLabel.text = self.photo.description
    self.separatorView.isHidden = (self.photo.description == nil)
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(title: "Info")
    self.navigationItem.leftBarButtonItem = .init(customView: self.closeButton)
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: InfoPhotoViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestInfo: self.rx
        .viewDidLoad
        .compactMap { [weak self] _ -> Photo? in return self?.photo }
    ))

    outputs.sections
      .drive(self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.closeButton.rx
      .tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)

    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension InfoPhotoViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return .init(width: collectionView.frame.width / 2, height: 40)
  }
}
