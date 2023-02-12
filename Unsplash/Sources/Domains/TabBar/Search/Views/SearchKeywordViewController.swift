//
//  SearchKeywordViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/19.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class SearchKeywordViewController: BaseViewController {

  // MARK: - UI Components

  private let collectionView: PhotoWaterfallCollectionView = {
    let view: PhotoWaterfallCollectionView = .init()
    view.showOwner = true
    return view
  }()


  // MARK: - Properties

  private let viewModel: SearchKeywordViewModel

  private let keyword: String


  // MARK: - Initializers

  init(viewModel: SearchKeywordViewModel, keyword: String) {
    self.viewModel = viewModel
    self.keyword = keyword

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
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.left.right.bottom.equalToSuperview()
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(title: self.keyword)
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: SearchKeywordViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestCategoryPhotos: self.rx
        .viewDidLoad
        .compactMap { [weak self] _ -> String? in return self?.keyword }
    ))

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.categoryPhotos
      .drive(onNext: { [weak self] (photos: [Photo]) in self?.collectionView.photos = photos })
      .disposed(by: self.disposeBag)
  }
}
