
import UIKit
import SnapKit

protocol CalendarControlProtocol: AnyObject {
    func dateСhanged(_ newData: Date? )
}

class CalendarControl: UIControl {
    
    //MARK: - Naming
    
    private let daysCollectionViewTopInset: CGFloat = 12
    private let weekDaysStackViewHeight: CGFloat = 32
    private let weekDaysStackViewTopInset: CGFloat = 16
    private let monthStackViewHeight: CGFloat = 26
    private let monthStackViewTopInset: CGFloat = 26
    private let daysCollectionViewBottomInset: CGFloat = 26
    
    weak var delegate: CalendarControlProtocol?
    
    private var calendar = Calendar.current
    
    private var isPickerShown: Bool = false
    
    private var currentDate: Date { Date() }
    
    private var currentYear: Int {
        calendar.component(.year, from: currentDate)
    }
    
    private var currentMonth: Int {
        calendar.component(.month, from: currentDate)
    }
    
    private var currentDay: Int {
        calendar.component(.day, from: currentDate)
    }
    
    private lazy var selectedYear = currentYear {
        didSet {
            yearLabel.text = String(selectedYear)
            monthCalendar = generateMonthCalendar()
        }
    }
    
    private lazy var selectedMonth: Int = currentMonth {
        didSet {
            monthLabel.text = selectedMonthName()
            monthCalendar = generateMonthCalendar()
        }
    }
    
    private lazy var selectedDate: Date? = makeDateFromComponents(day: currentDay) {
        didSet{
            delegate?.dateСhanged(selectedDate)
        }
    }
    
    private lazy var monthCalendar: [Date]? = {
        generateMonthCalendar()
    }()
    
    // MARK: - Month section
    
    private lazy var previousMonthImageView: UIImageView =  {
        let imageView = UIImageView(image: .previousMonth)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setPreviousMonth)))
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .black.withAlphaComponent(0.4)
        return imageView
    }()

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = selectedMonthName()
        label.textAlignment = .center
        label.font = InterFont.medium.of(size: 20)
        return label
    }()
    
    private lazy var nextMonthImageView: UIImageView  = {
        let imageView = UIImageView(image: .nextMonth)
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setNextMonth)))
        return imageView
    }()
    
    private lazy var monthStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousMonthImageView, monthLabel, nextMonthImageView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Уear section
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.text = String(selectedYear)
        label.font = InterFont.regular.of(size: 20)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var yearPickerImageView: UIImageView  = {
        let imageView = UIImageView(image: .yearPicker)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedYearPicker)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var yearBorderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        return view
    }()
    
    private lazy var yearPickerTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(YearPickerTableViewCell.self, forCellReuseIdentifier: YearPickerTableViewCell.identifier)
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.themeRed.withAlphaComponent(0.4).cgColor
        tableView.layer.cornerRadius = 7
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Day section
    
    private var weekDayLabel: UILabel {
        let label = UILabel()
        label.textColor = .grayFont
        label.font = InterFont.regular.of(size: 18)
        label.textAlignment = .center
        return label
    }
    
    private let weekDays: [String] = ["M", "T", "W", "T", "F", "S", "S"]
    
    private lazy var weekDaysStackView: UIStackView = {
        let stackView = UIStackView()
        for weekDay in weekDays {
            let label = weekDayLabel
            label.text = weekDay
            stackView.addArrangedSubview(label)
        }
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 14.83
        return stackView
    }()
    
    private lazy var daysCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CalendarFlowLayout(inset: 14.83, scrollDirection: .vertical))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Life cycle
    
    init() {
        super.init(frame: .zero)
        calendar.timeZone = TimeZone.current
        setupView()
        addTarget(self, action: #selector(dismissYearPicker), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func setSelectedDate(with date: Date) {
        selectedYear = calendar.component(.year, from: date)
        selectedMonth = calendar.component(.month, from: date)
        selectedDate = date
    }
    
    func selectedMonthName() -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM"
        
        var components = DateComponents()
        components.month = selectedMonth
        components.year = selectedYear
        
        if let date = calendar.date(from: components) {
            return formatter.string(from: date)
        }
        return nil
    }
    
    func getSizeToHeight() -> CGFloat {
        daysCollectionView.contentSize.height + daysCollectionViewTopInset + weekDaysStackViewHeight + weekDaysStackViewTopInset + monthStackViewHeight + monthStackViewTopInset + daysCollectionViewBottomInset
    }
    
    private func setupView() {
        
        addSubview(monthStackView)
        addSubview(yearBorderView)
        yearBorderView.addSubview(yearLabel)
        yearLabel.addSubview(yearPickerImageView)
        addSubview(weekDaysStackView)
        addSubview(daysCollectionView)
        
        
        monthStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(monthStackViewTopInset)
            make.leading.equalToSuperview().offset(21)
            make.height.equalTo(monthStackViewHeight)
            make.width.equalTo(173)
        }
        
        previousMonthImageView.snp.makeConstraints { make in
            make.width.equalTo(26)
        }
        
        nextMonthImageView.snp.makeConstraints { make in
            make.width.equalTo(26)
        }
        
        yearBorderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(93)
            make.height.equalTo(40)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview().offset(12)
            make.width.equalTo(72)
            make.height.equalTo(24)
        }
        
        yearPickerImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview()
            make.width.equalTo(16)
        }
        
        weekDaysStackView.snp.makeConstraints { make in
            make.top.equalTo(monthStackView.snp.bottom).offset(weekDaysStackViewTopInset)
            make.leading.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(weekDaysStackViewHeight)
        }
        
        daysCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekDaysStackView.snp.bottom).offset(daysCollectionViewTopInset)
            make.leading.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
        }
    }
    
    private func setMonth(with step: Int) {
        var newMonth = selectedMonth + step
        
        if newMonth > 12 {
            newMonth -= 12
        }
        
        if newMonth < 1 {
            newMonth += 12
        }
        
        selectedMonth = newMonth
    }
    
    private func makeDateFromComponents(year: Int? = nil, month: Int? = nil, day: Int? = nil) -> Date? {
        var dateComponents = DateComponents()
        if let year { dateComponents.year = year } else { dateComponents.year = selectedYear }
        if let month { dateComponents.month = month } else { dateComponents.month = selectedMonth }
        if let day { dateComponents.day = day } else { dateComponents.day = currentDay }
        dateComponents.hour = 12
        return calendar.date(from: dateComponents)
    }
    
    private func generateMonthCalendar() -> [Date]? {
        guard let date = makeDateFromComponents() else { return nil }
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = .current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        guard let firstOfMonth = calendar.date(from: components),
              let _ = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let weekdayIndex = (weekday + 5) % 7
        var dates: [Date] = []
        if let calendarStart = calendar.date(byAdding: .day, value: -weekdayIndex, to: firstOfMonth) {
            
            for i in 0..<42 {
                if let date = calendar.date(byAdding: .day, value: i, to: calendarStart) {
                    dates.append(date)
                }
            }
        }
        return dates
    }
    
    @objc private func setPreviousMonth() {
        setMonth(with: -1)
        daysCollectionView.reloadData()
    }
    
    @objc private func setNextMonth() {
        setMonth(with: 1)
        daysCollectionView.reloadData()
    }
    
    @objc private func didTappedYearPicker() {
        guard !isPickerShown else {
            dismissYearPicker()
            return
        }
        isPickerShown = true
        yearBorderView.layer.borderColor = UIColor.themeRed.withAlphaComponent(0.4).cgColor
        
        addSubview(yearPickerTableView)
        
        yearPickerTableView.snp.makeConstraints { make in
            make.top.equalTo(yearBorderView.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
            make.width.equalTo(108)
            make.height.equalTo(224)
        }
    }
    
    @objc private func dismissYearPicker() {
        guard isPickerShown else { return }
        isPickerShown = false
        yearBorderView.layer.borderColor = UIColor.clear.cgColor
        yearPickerTableView.removeFromSuperview()
    }
}

extension CalendarControl: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YearPickerTableViewCell.identifier) as? YearPickerTableViewCell else {
            return UITableViewCell()
        }
        let year = currentYear + indexPath.row
        cell.configure(with: year, isSelected: year == selectedYear)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newYear = currentYear + indexPath.row
        selectedYear = newYear
        tableView.reloadData()
        dismissYearPicker()
        daysCollectionView.reloadData()
    }
}

extension CalendarControl: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell, let calendar = monthCalendar, let selectedDate else {
            return UICollectionViewCell()
        }
        let dayDate = calendar[indexPath.row]
        let day = self.calendar.component(.day, from: dayDate)
        let mounth = self.calendar.component(.month, from: dayDate)
        let selectedDayByUser = self.calendar.component(.day, from: selectedDate)
        let selectedMounthByUser = self.calendar.component(.month, from: selectedDate)
        let selectedYearByUser = self.calendar.component(.year, from: selectedDate)
        
        let isSelectedDay = (selectedDayByUser == day) && (selectedMounthByUser == mounth) && (selectedYearByUser == selectedYear)
        
        cell.configure(with: day, isSelectedMonth: selectedMonth == mounth, isSelectedDay: isSelectedDay, isCurrentDay: (day == currentDay) && (selectedMonth == currentMonth) && (selectedYear == currentYear))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dayDate = monthCalendar?[indexPath.row], calendar.component(.month, from: dayDate) == selectedMonth else { return }
        
        if calendar.component(.day, from: dayDate) >= calendar.component(.day, from: currentDate) || ((selectedMonth > currentMonth) && (currentYear == selectedYear)) || selectedYear > currentYear {
            selectedDate = dayDate
            daysCollectionView.reloadData()
        }
    }
}

extension CalendarControl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = 14.83
        let numberOfColumns: CGFloat = 7
        let totalSpacing = inset * (numberOfColumns - 1)
        let itemWidth = (frame.width - 40 - totalSpacing) / numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
