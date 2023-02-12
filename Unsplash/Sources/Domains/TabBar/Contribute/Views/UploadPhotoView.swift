//
//  UploadPhotoView.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/10.
//

import SnapKit
import UIKit


final class UploadPhotoView: BaseView {

  // MARK: - UI Components

  private let imageView: BaseImageView = {
    let image: UIImage? = .init(named: "upload_photo_icon")
    let view: BaseImageView = .init(image: image)
    view.contentMode = .scaleAspectFit
    return view
  }()

  private let label: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 15)
    label.text = "Upload your photo to the largest\nlibrary of open photography."
    label.textColor = .white.withAlphaComponent(0.8)
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()


  // MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()

    self.addDashBorder(
      fillColor: .clear,
      strokeColor: .init(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0),
      cornerRadius: 15,
      lineWidth: 3,
      lineDashPattern: [7]
    )
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.add(
      self.imageView,
      self.label
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.imageView.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(30)
      make.width.equalTo(130)
      make.height.equalTo(100)
    }

    self.label.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.imageView.snp.bottom)
      make.bottom.equalToSuperview().inset(40)
    }
  }
}
