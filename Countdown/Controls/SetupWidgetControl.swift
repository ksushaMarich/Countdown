
import UIKit
import SnapKit

protocol SetupWidgetControlDelegate: AnyObject {
    func newWidgetBackgroundStateIsSelected(_ state: WidgetBackgroundState)
    func presentPaywall()
}

final class SetupWidgetControl: UIControl {
    
    //MARK: - Naming
    
    weak var delegate: SetupWidgetControlDelegate?
    
    //MARK: - Gradients сolors
    
    private let isSubscriptionReminder: Bool
    
    private var baseWidgetViewWidth: CGFloat = CGFloat.proportionalToDesignHeight(155)
    
    private var timeWidgetViewWidth: CGFloat = CGFloat.proportionalToDesignHeight(310)
    
    private let isSmallScreen = UIScreen.main.bounds.height < 700
    
    private let fontScaleFactor: Double = 56 / 68
    
    private var daysNumberLeftLabelFontSize: CGFloat {
        let fontSize: CGFloat = 68
        return isSmallScreen ? (fontSize * fontScaleFactor) : fontSize
    }
    
    private var timeLabelFontSize: CGFloat {
        let fontSize: CGFloat = 56
        return isSmallScreen ? (fontSize * fontScaleFactor) : fontSize
    }
    
    private var colonLabelFontSize: CGFloat {
        let fontSize: CGFloat = 44
        return isSmallScreen ? (fontSize * fontScaleFactor) : fontSize
    }
    
    private var isTimeWidgetViewOpened = false
    
    private var spacingBetweenCentersWidgetViews: CGFloat = 0
    
    private var baseWidgetCenterXConstraint: Constraint?
    
    private lazy var colors: [GradientsСolors] = {
        var colors: [GradientsСolors] = []
        for gradient in WidgetTheme.colors {
            colors.append(GradientsСolors(colors: gradient))
        }
        return colors
    }()
    
    private var colorsViews: [UIView] {
        var views: [UIView] = []
        for gradientsСolors in colors {
            views.append(WidgetBackgroundCellView(colors: gradientsСolors.colors))
        }
        return views
    }
    
    private var selectedColorIndex: Int = 0

    //MARK: - Texture images
    
    private lazy var images: [UIImage?] = WidgetTheme.images
    
    private var imageViews: [UIView?] {
        var views: [UIView?] = []
        for image in images {
            if let image {
                views.append(WidgetBackgroundCellView(image: image))
            } else {
                views.append(nil)
            }
        }
        return views
    }
    
    private var selectedTextureIndex: Int = 0
    
    //MARK: - Widget view
    
    private var widgetView: UIView {
        let view = WidgetBackgroundCellView(colors: colors[selectedColorIndex].colors)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat.proportionalToDesignHeight(28)
        return view
    }
    
    private lazy var baseWidgetView = widgetView
    
    private lazy var timeWidgetView = widgetView
    
    private let baseGradientLayer = CAGradientLayer()
    
    private var widgetTextureImageView: UIImageView {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat.proportionalToDesignHeight(28)
        view.alpha = 0.1
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = false
        return view
    }
    
    private lazy var baseWidgetTextureImageView = widgetTextureImageView
    
    private lazy var timeWidgetTextureImageView = widgetTextureImageView
    
    private var eventNameLabel: UILabel {
        let label = UILabel()
        label.font = InterFont.bold.of(size: 12)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        return label
    }
    
    private lazy var eventBaseNameLabel = eventNameLabel
    
    private lazy var eventTimeNameLabel: UILabel = {
        let label = eventNameLabel
        label.font = InterFont.bold.of(size: 14)
        return label
    }()
    
    private var daysNumberLeftLabel: UILabel {
        let label = UILabel()
        label.font = InterFont.bold.of(size: daysNumberLeftLabelFontSize)
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        return label
    }
    
    private lazy var baseDaysNumberLeftLabel = daysNumberLeftLabel
    
    private lazy var timeDaysNumberLeftLabel: UILabel = {
        let label = daysNumberLeftLabel
        label.textAlignment = .center
        return label
    }()
    
    private var daysLeftTitleLabel: UILabel {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 12)
        label.textColor = .white
        label.text = "days left"
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        return label
    }
    
    private lazy var baseDaysLeftTitleLabel = daysLeftTitleLabel
    
    private lazy var timeDaysLeftTitleLabel: UILabel = {
        let label = daysLeftTitleLabel
        label.text = "days"
        return label
    }()
    
    private lazy var hourLeftTitleLabel: UILabel = {
        let label = daysLeftTitleLabel
        label.text = "hours"
        return label
    }()
    
    private lazy var minuteLeftTitleLabel: UILabel = {
        let label = daysLeftTitleLabel
        label.text = "min"
        return label
    }()
    
    private var dateLabel: UILabel {
        let label = UILabel()
        label.font = InterFont.medium.of(size: 12)
        label.textColor = .white
        label.isUserInteractionEnabled = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        return label
    }
    
    private lazy var baseDateLabel = dateLabel
    
    private lazy var timeDateLabel = dateLabel
    
    private var timeLabel: UILabel {
        let label = UILabel()
        label.font = HelveticaNeueFont.bold.of(size: timeLabelFontSize)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }
    
    private lazy var minuteNumberTimeLabel = timeLabel
    
    private lazy var hourNumberTimeLabel = timeLabel
    
    private lazy var colonLabel: UILabel = {
        let label = UILabel()
        label.font = HelveticaNeueFont.bold.of(size: colonLabelFontSize)
        label.textColor = .white
        label.text = ":"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var customPageControl = CustomPageControl()
    
    private lazy var chooseWidgetColorControl: ChooseWidgetBackgroundControl = {
        let chooseWidgetBackgroundControl = ChooseWidgetBackgroundControl(title: "Color", views: colorsViews, selectedIndex: selectedColorIndex, type: .color)
        chooseWidgetBackgroundControl.delegate = self
        return chooseWidgetBackgroundControl
    }()
    
    private lazy var chooseWidgetImageControl:
    ChooseWidgetBackgroundControl = {
        let chooseWidgetBackgroundControl = ChooseWidgetBackgroundControl(title: "Texture", views: imageViews, selectedIndex: selectedTextureIndex, type: .image)
        chooseWidgetBackgroundControl.delegate = self
        chooseWidgetBackgroundControl.tag = 1
        return chooseWidgetBackgroundControl
    }()
    
    //MARK: - Life cycle
    
    init(isSubscriptionReminder: Bool = false) {
        self.isSubscriptionReminder = isSubscriptionReminder
        super .init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        baseGradientLayer.frame = baseWidgetView.bounds
        
        spacingBetweenCentersWidgetViews = bounds.width / 2 + timeWidgetViewWidth / 2
        
        timeWidgetView.snp.updateConstraints { make in
            make.centerX.equalTo(baseWidgetView.snp.centerX).offset(spacingBetweenCentersWidgetViews)
        }
        
        if isSubscriptionReminder {
            for view in [baseWidgetView, timeWidgetView] {
                applyShadowWithSpread(to: view, color: UIColor.themeRed, alpha: 0.16, x: 0, y: 0, blur: 14.7, spread: 12)
            }
            chooseWidgetColorControl.backgroundColor = .white.withAlphaComponent(0.4)
            chooseWidgetImageControl.backgroundColor = .white.withAlphaComponent(0.4)
        }
        applyVerticalGradient(with: colors[selectedColorIndex].colors)
    }
    
    //MARK: - Methods
    
    func configure(with event: Countdown.Event) {
        eventBaseNameLabel.text = event.name
        eventTimeNameLabel.text = event.name
        if let daysLeft = event.getTimeLeft() {
            configureDaysNumberLeftLabels(days: daysLeft.days)
            hourNumberTimeLabel.text = "\(daysLeft.hours)"
            minuteNumberTimeLabel.text = "\(daysLeft.minutes)"
        }
        let dateString = DateFormatterService.makeStringForEventTableViewCell(for: event.date, time: nil)
        baseDateLabel.text = dateString
        timeDateLabel.text = dateString
        addPanGestureRecognizer()
        selectedColorIndex = event.widgetBackgroundState.colorIndex
        selectedTextureIndex = event.widgetBackgroundState.imageIndex
        chooseWidgetColorControl.setSelectedIndex(selectedColorIndex)
        chooseWidgetImageControl.setSelectedIndex(selectedTextureIndex)
   
        for textureImageView in [baseWidgetTextureImageView, timeWidgetTextureImageView] {
            textureImageView.image = images[selectedTextureIndex]
        }
    }
    
    func applyShadowWithSpread(to view: UIView,
                               color: UIColor = .black,
                               alpha: Float = 0.2,
                               x: CGFloat = 0,
                               y: CGFloat = 2,
                               blur: CGFloat = 20,
                               spread: CGFloat = 12) {
        
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = alpha
        view.layer.shadowOffset = CGSize(width: x, height: y)
        view.layer.shadowRadius = blur / 2.0
        view.layer.masksToBounds = false
        
        if spread == 0 {
            view.layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = view.bounds.insetBy(dx: dx, dy: dx)
            view.layer.shadowPath = UIBezierPath(
                roundedRect: rect,
                cornerRadius: view.layer.cornerRadius
            ).cgPath
        }
    }
    
    private func configureDaysNumberLeftLabels(days: Int) {
        if days > 9 {
            for label in [baseDaysNumberLeftLabel, timeDaysNumberLeftLabel] {
                label.adjustsFontSizeToFitWidth = true
                label.numberOfLines = 1
                label.minimumScaleFactor = 0.1
                label.text = "\(days)"
            }
        } else {
            for label in [baseDaysNumberLeftLabel, timeDaysNumberLeftLabel] {
                label.adjustsFontSizeToFitWidth = false
                label.text = "\(days)"
            }
        }
    }
    
    private func setup() {
        
        addSubview(baseWidgetView)
        baseWidgetView.addSubview(baseWidgetTextureImageView)
        baseWidgetView.addSubview(eventBaseNameLabel)
        baseWidgetView.addSubview(baseDaysNumberLeftLabel)
        baseWidgetView.addSubview(baseDaysLeftTitleLabel)
        baseWidgetView.addSubview(baseDateLabel)
        
        addSubview(timeWidgetView)
        timeWidgetView.addSubview(timeWidgetTextureImageView)
        timeWidgetView.addSubview(eventTimeNameLabel)
        timeWidgetView.addSubview(timeDateLabel)
        timeWidgetView.addSubview(timeDaysNumberLeftLabel)
        timeWidgetView.addSubview(minuteNumberTimeLabel)
        timeWidgetView.addSubview(colonLabel)
        timeWidgetView.addSubview(hourNumberTimeLabel)
        timeWidgetView.addSubview(timeDaysLeftTitleLabel)
        timeWidgetView.addSubview(hourLeftTitleLabel)
        timeWidgetView.addSubview(minuteLeftTitleLabel)
        
        addSubview(customPageControl)
        
        addSubview(chooseWidgetColorControl)
        addSubview(chooseWidgetImageControl)
        
        //MARK: - baseWidgetView
        
        baseWidgetView.snp.makeConstraints { make in
            self.baseWidgetCenterXConstraint = make.centerX.equalToSuperview().constraint
            make.top.equalToSuperview()
            make.width.height.equalTo(baseWidgetViewWidth)
        }
        
        baseWidgetTextureImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        eventBaseNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(15))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(15))
        }
        
        baseDaysNumberLeftLabel.snp.makeConstraints { make in
            make.top.equalTo(eventBaseNameLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(2))
            make.leading.equalTo(eventBaseNameLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        baseDaysLeftTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseDaysNumberLeftLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(CGFloat.proportionalToDesignHeight(15))
        }
        
        baseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(baseDaysLeftTitleLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(3))
            make.leading.equalTo(baseDaysLeftTitleLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(CGFloat.proportionalToDesignHeight(15))
            make.bottom.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(-15))
        }
        
        //MARK: - timeWidgetView
        
        timeWidgetView.snp.makeConstraints { make in
            make.top.height.equalTo(baseWidgetView)
            make.width.equalTo(timeWidgetViewWidth)
            make.centerX.equalTo(baseWidgetView.snp.centerX).offset(spacingBetweenCentersWidgetViews)
        }
        
        timeWidgetTextureImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        eventTimeNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(15))
            make.leading.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(CGFloat.proportionalToDesignHeight(17))
        }
        
        timeDateLabel.snp.makeConstraints { make in
            make.top.equalTo(eventTimeNameLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(3))
            make.leading.equalTo(eventTimeNameLabel)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(15))
        }
        
        timeDaysNumberLeftLabel.snp.makeConstraints { make in
            make.top.equalTo(timeDateLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(7))
            make.leading.equalTo(timeDateLabel)
            make.bottom.equalTo(timeDaysLeftTitleLabel.snp.top).offset(CGFloat.proportionalToDesignWidth(-9))
            make.width.equalTo(CGFloat.proportionalToDesignWidth(75))
        }
        
        timeDaysLeftTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(timeDaysNumberLeftLabel)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(14))
            make.bottom.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(-15))
        }
        
        minuteNumberTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(-34))
            make.bottom.equalTo(hourLeftTitleLabel.snp.top).offset(CGFloat.proportionalToDesignWidth(4))
        }
        
        colonLabel.snp.makeConstraints { make in
            make.trailing.equalTo(minuteNumberTimeLabel.snp.leading).offset(CGFloat.proportionalToDesignWidth(-4))
            make.centerY.equalTo(minuteNumberTimeLabel)
        }
        
        hourNumberTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(colonLabel.snp.leading).offset(CGFloat.proportionalToDesignWidth(-4))
            make.centerY.equalTo(colonLabel)
        }
        
        hourLeftTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(timeDaysLeftTitleLabel)
            make.centerX.equalTo(hourNumberTimeLabel)
        }
        
        minuteLeftTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(hourLeftTitleLabel)
            make.centerX.equalTo(minuteNumberTimeLabel)
        }
        
        //MARK: - customPageControl
        
        customPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(baseWidgetView.snp.bottom).offset(CGFloat.proportionalToDesignHeight(24))
        }
        
        //MARK: - chooseWidgetColorControl
        
        chooseWidgetColorControl.snp.makeConstraints { make in
            make.top.equalTo(customPageControl.snp.bottom).offset(CGFloat.proportionalToDesignHeight(26))
            make.leading.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(CGFloat.proportionalToDesignHeight(117))
        }
        
        chooseWidgetImageControl.snp.makeConstraints { make in
            make.top.equalTo(chooseWidgetColorControl.snp.bottom).offset(CGFloat.proportionalToDesignHeight(20))
            make.centerX.equalToSuperview()
            make.leading.equalTo(chooseWidgetColorControl)
            make.height.equalTo(chooseWidgetColorControl)
        }
    }
    
    private func addPanGestureRecognizer() {
        let basePanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        basePanGesture.delegate = self
        let timePanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        timePanGesture.delegate = self
        baseWidgetView.addGestureRecognizer(basePanGesture)
        timeWidgetView.addGestureRecognizer(timePanGesture)
    }
    
    private func applyVerticalGradient(with colors: [UIColor]) {
        guard !colors.isEmpty else { return }

        baseWidgetView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        timeWidgetView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        func makeGradient(for view: UIView) -> CAGradientLayer {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.frame = view.bounds
            gradientLayer.cornerRadius = view.layer.cornerRadius
            return gradientLayer
        }

        baseWidgetView.layer.insertSublayer(makeGradient(for: baseWidgetView), at: 0)
        timeWidgetView.layer.insertSublayer(makeGradient(for: timeWidgetView), at: 0)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self)
            
        guard abs(translation.x) > abs(translation.y) else { return }
        
        switch gesture.state {
        case .changed:
            let offsetX = isTimeWidgetViewOpened ? min(0, translation.x - timeWidgetViewWidth) : max(-timeWidgetViewWidth, translation.x)
            baseWidgetCenterXConstraint?.update(offset: offsetX)
            customPageControl.updateCurrentPage(scrollPercentage: -offsetX/spacingBetweenCentersWidgetViews)
        layoutIfNeeded()
        case .ended:
             let threshold: CGFloat =  50
             let offset: CGFloat

             if abs(translation.x) < threshold {
                 offset = isTimeWidgetViewOpened ? -spacingBetweenCentersWidgetViews : 0
             } else {
                 if translation.x > 0 {
                     offset = 0
                     isTimeWidgetViewOpened = false
                 } else {
                     offset = -spacingBetweenCentersWidgetViews
                     isTimeWidgetViewOpened = true
                 }
             }

             UIView.animate(withDuration: 0.3) { [weak self] in
                 guard let self else { return }
                 self.baseWidgetCenterXConstraint?.update(offset: offset)
                 self.customPageControl.updateCurrentPage(scrollPercentage: -offset / self.spacingBetweenCentersWidgetViews)
                 self.layoutIfNeeded()
             }
            
        default:
            break
        }
    }
}

extension SetupWidgetControl: ChooseWidgetBackgroundControlDelegate {
    func newItemSelected(at index: Int, for type: ChooseWidgetBackgroundControlType) {
        if SubscriptionsService.shared.hasSubscription {
            switch type {
            case .color:
                selectedColorIndex = index
                applyVerticalGradient(with: colors[index].colors)
                chooseWidgetColorControl.setSelectedIndex(index)
            case .image:
                selectedTextureIndex = index
                for textureImageView in [baseWidgetTextureImageView, timeWidgetTextureImageView] {
                    textureImageView.image = images[index]
                }
                chooseWidgetImageControl.setSelectedIndex(index)
            }
            delegate?.newWidgetBackgroundStateIsSelected(WidgetBackgroundState(colorIndex: selectedColorIndex, imageIndex: selectedTextureIndex))
        } else {
            delegate?.presentPaywall()
        }
    }
}

extension SetupWidgetControl: UIGestureRecognizerDelegate {}
