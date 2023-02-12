//
//  StatViewController.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/31.
//

import Charts
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit


final class StatViewController: BaseViewController {

  // MARK: - UI Components

  private let chartView: LineChartView = {
    let view: LineChartView = .init()
    view.noDataText = ""
    view.xAxis.enabled = false
    view.legend.enabled = false
    view.leftAxis.drawLabelsEnabled = false
    view.leftAxis.drawAxisLineEnabled = false
    view.leftAxis.drawGridLinesEnabled = false
    view.rightAxis.enabled = false
    view.setScaleEnabled(false)
    view.pinchZoomEnabled = false
    view.doubleTapToZoomEnabled = false
    view.chartDescription.enabled = false
    return view
  }()

  private let segmentedControl: UISegmentedControl = {
    let segmentedControl: UISegmentedControl = .init(items: ["Views", "Downloads"])
    segmentedControl.selectedSegmentIndex = 0
    return segmentedControl
  }()

  private let countTitleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .boldSystemFont(ofSize: 15)
    label.text = "Views"
    label.textAlignment = .center
    return label
  }()

  private let countLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(30)
    label.text = "0"
    label.textAlignment = .center
    return label
  }()

  private let countSubtitleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 11)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()

  private let popularPhotosLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .pretendard.bold(20)
    label.text = "Popular photos"
    label.isHidden = true
    return label
  }()

  private let last30DaysButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.title = "Last 30 days"
    configuration.cornerStyle = .capsule
    configuration.baseBackgroundColor = .init(
      red: 235/255,
      green: 235/255,
      blue: 245/255,
      alpha: 1.0
    )

    let button: UIButton = .init(configuration: configuration)
    button.isSelected = true
    return button
  }()

  private let allTimeButton: UIButton = {
    var configuration: UIButton.Configuration = .plain()
    configuration.title = "All-time"
    configuration.cornerStyle = .capsule

    let button: UIButton = .init(configuration: configuration)
    return button
  }()

  private let quantityStackView: UIStackView = {
    let view: UIStackView = .init()
    view.axis = .horizontal
    view.spacing = 5
    view.distribution = .fillProportionally
    return view
  }()

  private let popularPhotoCollectionView: BaseCollectionView = {
    let layout: UICollectionViewFlowLayout = .init()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 18
    layout.minimumInteritemSpacing = 18

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
      cell.cornerRadius = 5
      return cell
    }
  )

  private let chartGradient: CGGradient = {
    let gradientColors: CFArray = [
      UIColor.darkGray.withAlphaComponent(0.0).cgColor,
      UIColor.darkGray.withAlphaComponent(1.0).cgColor
    ] as CFArray

    let gradient: CGGradient = .init(
      colorsSpace: CGColorSpaceCreateDeviceRGB(),
      colors: gradientColors,
      locations: [0.0, 0.5]
    )!

    return gradient
  }()

  private let quantityButtonTextAttributesTransfomer: UIConfigurationTextAttributesTransformer = .init({ (
    container: AttributeContainer
  ) -> AttributeContainer in
    var container: AttributeContainer = container
    container.font = .boldSystemFont(ofSize: 11)
    container.foregroundColor = .white
    return container
  })

  private var viewHistoricalValues: [StatHistoricalValue] = []

  private var downloadHistoricalValues: [StatHistoricalValue] = []

  private var viewTotal: Int = 0

  private var downloadTotal: Int = 0

  private var statType: StatType = .views

  private let viewModel: StatViewModel


  // MARK: - Initializers

  init(viewModel: StatViewModel) {
    self.viewModel = viewModel

    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .init(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
    self.chartView.delegate = self
  }


  // MARK: - Layout

  override func addSubviews() {
    super.addSubviews()

    self.view.add(
      self.segmentedControl,
      self.countTitleLabel,
      self.countLabel,
      self.countSubtitleLabel,
      self.chartView,
      self.quantityStackView.withArranged([
        self.last30DaysButton,
        self.allTimeButton
      ]),
      self.popularPhotosLabel,
      self.popularPhotoCollectionView
    )
  }

  override func setConstraints() {
    super.setConstraints()

    self.segmentedControl.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
      make.left.right.equalToSuperview().inset(15)
      make.height.equalTo(30)
    }

    self.countTitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.segmentedControl.snp.bottom).offset(25)
    }

    self.countLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.countTitleLabel.snp.bottom).offset(10)
    }

    self.countSubtitleLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.countLabel.snp.bottom).offset(10)
    }

    self.chartView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.countSubtitleLabel.snp.bottom).offset(20)
      make.width.equalToSuperview()
      make.height.equalTo(180)
    }

    self.quantityStackView.snp.makeConstraints { (make: ConstraintMaker) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.chartView.snp.bottom).offset(15)
    }

    self.popularPhotosLabel.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.quantityStackView.snp.bottom).offset(50)
      make.left.equalToSuperview().inset(15)
    }

    self.popularPhotoCollectionView.snp.makeConstraints { (make: ConstraintMaker) in
      make.top.equalTo(self.popularPhotosLabel.snp.bottom).offset(10)
      make.left.right.equalToSuperview().inset(15)
      make.height.equalTo(150)
    }
  }

  override func setComponents() {
    super.setComponents()

    let markerView: ChartMarkerView = .init()
    markerView.chartView = self.chartView
    markerView.backgroundColor = .init(red: 42/255, green: 42/255, blue: 44/255, alpha: 1.0)
    self.chartView.marker = markerView

    self.allTimeButton
      .configuration?
      .titleTextAttributesTransformer = self.quantityButtonTextAttributesTransfomer

    self.last30DaysButton
      .configuration?
      .titleTextAttributesTransformer = self.quantityButtonTextAttributesTransfomer
  }

  override func setNavigationBar() {
    super.setNavigationBar()

    self.navigationItem.setTitleView(title: "Stats", titleFont: .boldSystemFont(ofSize: 19))
  }


  // MARK: - Bind

  override func bind() {
    super.bind()

    let outputs: StatViewModel.Outputs = self.viewModel.transform(inputs: .init(
      requestMyStat: self.rx
        .viewDidLoad
        .compactMap { _ -> User? in return .me },
      requestPopularPhotos: self.rx
        .viewDidLoad
        .compactMap { _ -> User? in return .me }
    ))

    outputs.isPopularPhotoEmpty
      .drive(self.popularPhotosLabel.rx.isHidden)
      .disposed(by: self.disposeBag)

    outputs.popularPhotoSections
      .drive(self.popularPhotoCollectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    outputs.presentAlert
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)

    outputs.stat
      .drive(onNext: { [weak self] (stat: Stat) in
        self?.setStat(stat)
        self?.updateStat()
      })
      .disposed(by: self.disposeBag)

    self.popularPhotoCollectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)

    self.segmentedControl.rx
      .selectedSegmentIndex
      .subscribe(onNext: { [weak self] (index: Int) in
        self?.statType = (index == 0) ? .views : .downloads
        self?.updateStat()
      })
      .disposed(by: self.disposeBag)

    self.allTimeButton.rx
      .tap
      .map { _ -> RxAlert<Void> in return .init(
        actions: [.init(style: .cancel, title: "OK", value: ())],
        message: "Unsplash does not provide an API for all-time stats.",
        title: nil
      )}
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.presentAlert)
      .disposed(by: self.disposeBag)
  }


  // MARK: - Methods (Private)

  private func setStat(_ stat: Stat) {
    self.viewTotal = stat.viewStat.total
    self.downloadTotal = stat.downloadStat.total
    self.viewHistoricalValues = stat.viewStat.historical.values
    self.downloadHistoricalValues = stat.downloadStat.historical.values
  }

  private func updateStat() {
    switch self.statType {
    case .downloads:
      self.setChartData(historicalValues: self.downloadHistoricalValues)
      self.countLabel.text = "\(self.downloadTotal)"
      self.countTitleLabel.text = "Downloads"
      self.countSubtitleLabel.text = "Keep bringing your A-game!"

    case .views:
      self.setChartData(historicalValues: self.viewHistoricalValues)
      self.countLabel.text = "\(self.viewTotal)"
      self.countTitleLabel.text = "Views"
      self.countSubtitleLabel.text = "You've got this 🙌"
    }
  }

  private func setChartData(historicalValues: [StatHistoricalValue]) {
    let chartDataEntries: [ChartDataEntry] = historicalValues
      .enumerated()
      .map { (
        sequence: EnumeratedSequence<[StatHistoricalValue]>.Iterator.Element
      ) -> ChartDataEntry in
        return .init(
          x: Double(sequence.offset),
          y: Double(sequence.element.value)
        )
      }

    let chartDataSet: LineChartDataSet = .init(entries: chartDataEntries, label: "")
    chartDataSet.mode = .cubicBezier
    chartDataSet.fill = LinearGradientFill(gradient: self.chartGradient, angle: 90)
    chartDataSet.fillAlpha = 1.0
    chartDataSet.lineWidth = 2.0
    chartDataSet.drawFilledEnabled = true
    chartDataSet.drawValuesEnabled = false
    chartDataSet.drawCirclesEnabled = false
    chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
    chartDataSet.setColor(.white)
    chartDataSet.highlightColor = .lightGray
    chartDataSet.highlightEnabled = true
    chartDataSet.highlightLineDashLengths = [2.5]

    let chartData: LineChartData = .init(dataSet: chartDataSet)
    self.chartView.data = chartData
    self.chartView.highlightValues(nil)
    self.chartView.leftAxis.resetCustomAxisMax()
    self.chartView.leftAxis.axisMinimum = 0
    self.chartView.leftAxis.axisMaximum = Double(chartDataSet.yMax * 2) + 1
    self.chartView.animate(yAxisDuration: 0.5)
  }

  fileprivate func setMarkerValue(_ value: StatHistoricalValue) {
    guard let markerView = self.chartView.marker as? ChartMarkerView else { return }

    let dateFormatter: DateFormatter = .init()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let paragraphStyle: NSMutableParagraphStyle = .init()
    paragraphStyle.alignment = .center

    let attributedFont: UIFont = .systemFont(ofSize: 13)
    let attributedColor: UIColor = .white.withAlphaComponent(0.6)
    let attributes: [NSAttributedString.Key: Any] = [
      .font: attributedFont,
      .foregroundColor: attributedColor,
      .paragraphStyle: paragraphStyle
    ]

    if let date: Date = dateFormatter.date(from: value.date) {
      dateFormatter.dateFormat = "MMMM dd, yyyy"
      let firstLineText: String = dateFormatter.string(from: date)

      let suffix: String = (self.statType == .downloads) ? "downloads" : "views"
      let secondLineText: String = "\(value.value) " + suffix

      let text: String = firstLineText + "\n" + secondLineText
      let secondLineRange: NSRange = (text as NSString).range(of: secondLineText)
      let secondLineColor: UIColor = .white.withAlphaComponent(0.9)

      let attributedString: NSMutableAttributedString = .init(string: text, attributes: attributes)
      attributedString.addAttributes([.foregroundColor: secondLineColor], range: secondLineRange)
      markerView.setText(attributedString)
    }
  }
}


// MARK: - ChartViewDelegate

extension StatViewController: ChartViewDelegate {

  func chartValueSelected(
    _ chartView: ChartViewBase,
    entry: ChartDataEntry,
    highlight: Highlight
  ) {
    if let chartData: ChartData = chartView.data, chartData.count > 1 {
      _ = chartData.removeLast()
    }

    let chartDataSet: LineChartDataSet = .init(entries: [entry], label: "")
    chartDataSet.circleRadius = 8
    chartDataSet.circleHoleRadius = 4
    chartDataSet.circleColors = [.white]
    chartDataSet.circleHoleColor = .init(red: 75/255, green: 183/255, blue: 128/255, alpha: 1.0)
    chartDataSet.drawValuesEnabled = false
    chartDataSet.setDrawHighlightIndicators(false)
    chartView.data?.append(chartDataSet)

    let index: Int = .init(highlight.x)
    let historicalValue: StatHistoricalValue
    switch self.statType {
    case .downloads:
      historicalValue = self.downloadHistoricalValues[index]
    case .views:
      historicalValue = self.viewHistoricalValues[index]
    }

    self.setMarkerValue(historicalValue)
  }

  func chartValueNothingSelected(_ chartView: ChartViewBase) {
    if let chartData: ChartData = chartView.data, chartData.count > 1 {
      _ = chartData.removeLast()
    }
  }
}


// MARK: - UICollectionViewDelegate

extension StatViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let section: PhotoSection = self.dataSource.sectionModels[indexPath.section]
    let photo: Photo = section.items[indexPath.row]

    WindowRouter.tabBarController?.pushDetailPhoto(for: photo)
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension StatViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let numberOfCellsPerRow: CGFloat = 3
    let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    let space: CGFloat = (flowLayout.minimumInteritemSpacing * (numberOfCellsPerRow - 1))
      + flowLayout.sectionInset.right
      + flowLayout.sectionInset.left
    let width: CGFloat = (collectionView.bounds.width - space) / numberOfCellsPerRow
    return .init(width: width, height: width)
  }
}
