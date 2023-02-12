//
//  WebViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/11.
//

import SnapKit
import WebKit


final class WebViewController: BaseViewController {

  // MARK: - UI Components

  private let webView: WKWebView = .init()


  // MARK: - Properties

  private let url: URL


  // MARK: - Initializers

  init(url: URL) {
    self.url = url

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    let request: URLRequest = .init(url: self.url)
    self.webView.load(request)
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.webView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.webView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.left.right.bottom.equalToSuperview()
    }
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.title = self.title

    let appearance: UINavigationBarAppearance = .init()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .black
    UINavigationBar.appearance().standardAppearance = appearance
  }
}
