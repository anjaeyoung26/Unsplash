//
//  OnboardingViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/24.
//

import RxDataSources
import RxSwift
import RxViewController
import SnapKit
import UIKit


final class OnboardingViewController: BaseViewController {
  
  // MARK: - UI Components

  private let collectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.scrollDirection = .horizontal

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.isScrollEnabled = false
    view.register(PhotoCell.self)
    return view
  }()

  private let topGradientView: GradientView = {
    let view: GradientView = .init()
    view.gradientLayer.locations = [0.0, 1.0]
    view.gradientLayer.colors = [
      UIColor.black.withAlphaComponent(1.0).cgColor,
      UIColor.black.withAlphaComponent(0.0).cgColor
    ]
    return view
  }()

  private let bottomGradientView: GradientView = {
    let view: GradientView = .init()
    view.gradientLayer.locations = [0.0, 1.0]
    view.gradientLayer.colors = [
      UIColor.black.withAlphaComponent(0.0).cgColor,
      UIColor.black.withAlphaComponent(1.0).cgColor
    ]
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(33)
    label.text = "Beautiful, free photos"
    label.adjustsFontSizeToFitWidth = true
    return label
  }()

  private let subtitleView: UITextView = {
    let view: UITextView = .init()
    view.isEditable = false
    view.backgroundColor = .black
    view.showsVerticalScrollIndicator = false
    view.textContainer.lineFragmentPadding = 0

    let text = "Over 4 million photos\nHigh quality content you can download right now.\n\n" +
               "Curate your favourites\nCreate collections and like your top picks, all in one place.\n\n" +
               "Bring your next project to life\nNo matter what you need. you'll find the perfect image on Unsplash."

    let attributedString: NSMutableAttributedString = .init(string: text, attributes: [
      .font: UIFont.systemFont(ofSize: 17),
      .foregroundColor: UIColor.white
    ])

    attributedString.addAttributes(
      [.font: UIFont.boldSystemFont(ofSize: 17)],
      range: NSString(string: text).range(of: "Over 4 million photos")
    )
    attributedString.addAttributes(
      [.font: UIFont.boldSystemFont(ofSize: 17)],
      range: NSString(string: text).range(of: "Curate your favourites")
    )
    attributedString.addAttributes(
      [.font: UIFont.boldSystemFont(ofSize: 17)],
      range: NSString(string: text).range(of: "Bring your next project to life")
    )
    view.attributedText = attributedString

    return view
  }()

  private let browsingButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .white
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.titleLabel?.font = .boldSystemFont(ofSize: 18)
    button.setTitle("Start Browsing", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()

  private let coverView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .black
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
      return cell
    }
  )

  private let viewModel: OnboardingViewModel


  // MARK: - Initializers

  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel

    super.init()
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented.")
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.collectionView,
      self.topGradientView,
      self.bottomGradientView,
      self.titleLabel,
      self.subtitleView,
      self.browsingButton,
      self.coverView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.collectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.45)
    }

    self.topGradientView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalTo(self.collectionView)
      make.height.equalTo(self.collectionView).multipliedBy(0.3)
    }

    self.bottomGradientView.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.right.bottom.equalTo(self.collectionView)
      make.height.equalTo(self.collectionView).multipliedBy(0.5)
    }

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.collectionView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(30)
    }

    self.subtitleView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
      make.left.right.equalTo(self.titleLabel)
      make.bottom.equalTo(self.browsingButton.snp.top).offset(-20)
    }

    self.browsingButton.snp.makeConstraints { (make) in
      make.left.right.equalTo(self.titleLabel)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
      make.height.equalTo(45)
    }

    self.coverView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: OnboardingViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestComplete: self.browsingButton.rx
        .tap
        .throttle(.milliseconds(250), scheduler: MainScheduler.instance),
      loadPhotos: self.rx
        .viewDidLoad
        .map { _ -> Int in 15 }
    ))

    outputs.dismiss
      .drive(onNext: { [weak self] in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.sections
      .do(afterNext: { [weak self] _ in
        self?.startMarqueeAnimation()
        self?.hideCoverView()
      })
      .drive(self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func startMarqueeAnimation() {
    UIView.animate(
      withDuration: 0.001,
      delay: 0,
      animations: {
        self.collectionView.contentOffset.x = self.collectionView.contentOffset.x + 1
      },
      completion: { _ in
        let bottomX: CGFloat = self.collectionView.contentSize.width - self.collectionView.frame.size.width
        let isReachedBottom: Bool = self.collectionView.contentOffset.x >= bottomX

        if !isReachedBottom {
          self.startMarqueeAnimation()
        }
      })
  }

  private func hideCoverView() {
    UIView.animate(
      withDuration: 1.0,
      delay: 0,
      animations: { [weak self] in self?.coverView.alpha = 0 },
      completion: { [weak self] _ in self?.coverView.removeFromSuperview() }
    )
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let section: PhotoSection = self.dataSource.sectionModels[indexPath.section]
    let photo: Photo = section.items[indexPath.row]
    let height: CGFloat = collectionView.bounds.height
    let width: CGFloat = (photo.width * height) / photo.height
    return .init(width: width, height: height)
  }
}
