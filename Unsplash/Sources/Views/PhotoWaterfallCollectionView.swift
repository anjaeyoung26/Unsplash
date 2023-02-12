//
//  PhotoWaterfallCollectionView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/25.
//

import CHTCollectionViewWaterfallLayout
import RxCocoa
import RxSwift
import UIKit


final class PhotoWaterfallCollectionView: BaseCollectionView {

  // MARK: - Properties

  var columnCount: CGFloat = 2 {
    didSet { self.reloadData() }
  }

  var photos: [Photo] = [] {
    didSet { self.reloadData() }
  }

  var showOwner: Bool = false

  let waterfallLayout: CHTCollectionViewWaterfallLayout = {
    let layout: CHTCollectionViewWaterfallLayout = .init()
    layout.minimumColumnSpacing = 2
    layout.minimumInteritemSpacing = 2
    return layout
  }()


  // MARK: - Initializers

  init() {
    super.init(frame: .zero, collectionViewLayout: self.waterfallLayout)

    self.delegate = self
    self.dataSource = self
    self.register(PhotoCell.self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


// MARK: - UICollectionViewDataSource

extension PhotoWaterfallCollectionView: UICollectionViewDataSource {

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.photos.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let photo: Photo = self.photos[indexPath.row]
    let cell: PhotoCell = collectionView.dequeue(PhotoCell.self, for: indexPath)
    cell.configure(photo: photo, showOwner: self.showOwner)
    return cell
  }
}


// MARK: - UICollectionViewDelegate

extension PhotoWaterfallCollectionView: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    WindowRouter.tabBarController?.pushDetailPhoto(for: self.photos[indexPath.row])
  }
}


// MARK: - CHTCollectionViewDelegateWaterfallLayout

extension PhotoWaterfallCollectionView: CHTCollectionViewDelegateWaterfallLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let photo: Photo = self.photos[indexPath.row]
    let width: CGFloat = collectionView.frame.width / self.columnCount
    let height: CGFloat = .init(photo.height * width) / photo.width
    return .init(width: width, height: height)
  }
}
