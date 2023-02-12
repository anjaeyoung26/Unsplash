//
//  TopicViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/02.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class TopicViewController: BaseViewController {

  // MARK: - UI Components

  private let collectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 1

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.contentInsetAdjustmentBehavior = .never
    view.register(PhotoCell.self)
    view.register(TopicHeaderView.self, kind: UICollectionView.elementKindSectionHeader)
    return view
  }()


  // MARK: - Properties

  private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<PhotoSection> = .init(
    configureCell: { (
      dataSource: CollectionViewSectionedDataSource<PhotoSection>,
      collectionView: UICollectionView,
      indexPath: IndexPath,
      item: Photo
    ) -> UICollectionViewCell in
      let cell: PhotoCell = collectionView.dequeue(PhotoCell.self, for: indexPath)
      cell.configure(photo: item, showOwner: true)
      return cell
    },
    configureSupplementaryView: { [weak self] (
      dataSource: CollectionViewSectionedDataSource<PhotoSection>,
      collectionView: UICollectionView,
      kind: String,
      indexPath: IndexPath
    ) -> UICollectionReusableView in
      guard let self = self else { return .init() }

      if kind == UICollectionView.elementKindSectionHeader {
        let header: TopicHeaderView = collectionView.dequeue(
          TopicHeaderView.self,
          kind: kind,
          for: indexPath
        )
        header.configure(topic: self.topic)

        header.rx
          .didTapSubmitButton
          .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
          .bind(to: self.rx.presentSubmitSheet)
          .disposed(by: header.disposeBag)

        return header
      } else {
        fatalError("UICollectionView.elementKindSectionFooter not registered.")
      }
    }
  )

  fileprivate let sheetTransitionController: SheetTransitioningController = .init()

  fileprivate let topic: Topic

  private let viewModel: TopicViewModel


  // MARK: - Initializers

  init(viewModel: TopicViewModel, topic: Topic) {
    self.viewModel = viewModel
    self.topic = topic

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.collectionView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.collectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()
    
    let outputs: TopicViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestTopicPhotos: self.rx
        .viewDidLoad
        .compactMap { [weak self] _ -> String? in return self?.topic.id },
      requestMoreTopicPhotos: self.collectionView.rx
        .isReachedBottom(threshold: 15)
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .filter { (isReachedBottom: Bool) -> Bool in return isReachedBottom }
        .map { _ in }
    ))

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.sections
      .drive(self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)

    self.collectionView.rx
      .modelSelected(Photo.self)
      .subscribe(onNext: { (photo: Photo) in
        WindowRouter.tabBarController?.pushDetailPhoto(for: photo)
      })
      .disposed(by: self.disposeBag)
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension TopicViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let section: PhotoSection = self.dataSource.sectionModels[indexPath.section]
    let photo: Photo = section.items[indexPath.row]
    let height: CGFloat = (photo.height * collectionView.frame.width) / photo.width
    return .init(width: collectionView.frame.width, height: height)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return .init(width: collectionView.frame.width, height: collectionView.frame.height * 0.5)
  }
}


// MARK: - Reactive

extension Reactive where Base: TopicViewController {

  var presentSubmitSheet: Binder<Void> {
    return Binder(self.base) { (base: TopicViewController, _) in
      let viewController: SubmitSheetViewController = AppAssembler.resolve(
        SubmitSheetViewController.self,
        argument: base.topic
      )

      viewController.modalPresentationStyle = .custom
      viewController.transitioningDelegate = base.sheetTransitionController

      base.present(viewController, animated: true)
    }
  }
}



