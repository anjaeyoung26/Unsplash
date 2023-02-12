//
//  ThanksSubmitViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/12.
//

import CHTCollectionViewWaterfallLayout
import RxSwift
import SnapKit
import UIKit


final class ThanksSubmitViewController: BaseViewController {

  // MARK: - UI Components

  private let fanfareLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 55)
    label.text = "🎉"
    return label
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(22)
    label.text = "Thanks for submitting"
    label.textAlignment = .center
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 16)
    label.text = "Your photo is now being reviewed.\nOn behalf of everyone, we thank you."
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()

  private let doneButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .white
    button.layer.cornerRadius = 3
    button.layer.masksToBounds = true
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.setTitle("Done", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
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

  private let confettiView: ConfettiView = {
    let view: ConfettiView = .init()
    return view
  }()

  private let collectionView: BaseCollectionView = {
    let layout: CHTCollectionViewWaterfallLayout = .init()
    layout.columnCount = 3
    layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
    layout.minimumColumnSpacing = 17
    layout.minimumInteritemSpacing = 17

    let view: BaseCollectionView = .init(frame: .zero, collectionViewLayout: layout)
    view.register(PhotoCell.self)
    return view
  }()


  // MARK: - Properties

  private let photo: Photo


  // MARK: - Initializers

  init(photo: Photo) {
    self.photo = photo

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.confettiView.frame = self.view.frame
    self.confettiView.start()
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.startMarqueeAnimation()
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.collectionView,
      self.confettiView,
      self.topGradientView,
      self.bottomGradientView,
      self.fanfareLabel,
      self.titleLabel,
      self.subtitleLabel,
      self.doneButton
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.collectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.edges.equalToSuperview()
    }

    self.topGradientView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.left.right.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.3)
    }

    self.bottomGradientView.snp.makeConstraints { (make: ConstraintMaker) in
      make.left.right.bottom.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.3)
    }

    self.fanfareLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(self.titleLabel.snp.top).offset(-15)
    }

    self.titleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.center.equalToSuperview()
    }

    self.subtitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
    }

    self.doneButton.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.subtitleLabel.snp.bottom).offset(30)
      make.width.equalTo(87)
      make.height.equalTo(45)
    }
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    self.doneButton.rx
      .tap
      .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in self?.dismiss(animated: true) })
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func startMarqueeAnimation() {
    UIView.animate(
      withDuration: 0.001,
      delay: 0,
      animations: {
        self.collectionView.contentOffset.y = self.collectionView.contentOffset.y + 0.3
      },
      completion: { _ in
        let contentHeight: CGFloat = self.collectionView.contentSize.height
        let collectionViewHeight: CGFloat = self.collectionView.frame.height
        let bottomY: CGFloat = contentHeight - collectionViewHeight

        if !(self.collectionView.contentOffset.y >= bottomY) {
          self.startMarqueeAnimation()
        }
      })
  }
}


// MARK: - UICollectionViewDelegate

extension ThanksSubmitViewController: UICollectionViewDelegate {

}


// MARK: - UICollectionViewDataSource

extension ThanksSubmitViewController: UICollectionViewDataSource {

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 1000
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: PhotoCell = collectionView.dequeue(PhotoCell.self, for: indexPath)
    cell.imageContentMode = .scaleAspectFill
    cell.backgroundColor = .init(
      red: 43/255,
      green: 43/255,
      blue: 43/255,
      alpha: 1.0
    )

    if ((indexPath.row % 24 == 0) && (indexPath.row != 0)) || (indexPath.row == 8) {
      cell.configure(photo: self.photo)
    }

    return cell
  }
}


// MARK: - CHTCollectionViewDelegateWaterfallLayout

extension ThanksSubmitViewController: CHTCollectionViewDelegateWaterfallLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return .init(width: collectionView.frame.width / 3, height: CGFloat.random(in: 100...200))
  }
}
