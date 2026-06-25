
import UIKit
import SnapKit

protocol DropdownTablelViewDelegate: AnyObject {
    func newOptionIsSelected(for type: EventOptionsType, at index: Int)
    func addNewCategory()
}

class DropdownTablelView: UITableView {
    
    //MARK: - Naming
    
    weak var dropdownDelegate: DropdownTablelViewDelegate?
    
    private let type: EventOptionsType
    
    private let options: [String]
    
    private let colors: [UIColor]?
    
    private var selectedOptionIndex: Int
    
    //MARK: - Life cycle
    
    init(frame: CGRect, type: EventOptionsType, selectedIndex: Int) {
        self.type = type
        self.options = type.getOptions()
        self.colors = type.getColors()
        self.selectedOptionIndex = selectedIndex
        super.init(frame: frame, style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    //MARK: - Methods
    
    private func setup() {
        separatorStyle = .none
        layer.masksToBounds = true
        layer.cornerRadius = 7
        layer.borderWidth = 1
        layer.borderColor = UIColor.themeRed.withAlphaComponent(0.2).cgColor
        delegate = self
        dataSource = self
        register(DropdownTableViewCell.self, forCellReuseIdentifier: DropdownTableViewCell.identifier)
        register(AddCategoryTableViewCell.self, forCellReuseIdentifier: AddCategoryTableViewCell.identifier)
        showsVerticalScrollIndicator = false
        sectionHeaderTopPadding = 0
        contentInsetAdjustmentBehavior = .never
        if tableHeaderView == nil {
            tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 16))
        }
    }
}

extension DropdownTablelView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .category {
            return options.count + 1
        } else {
            return options.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == options.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCategoryTableViewCell.identifier) as? AddCategoryTableViewCell else {
                let cell = UITableViewCell()
                return cell }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropdownTableViewCell.identifier) as? DropdownTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        let currentIndex = indexPath.row
        cell.configure(with: options[currentIndex], color: colors?[currentIndex], isSelected: selectedOptionIndex == currentIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .category, indexPath.row == options.count {
            dropdownDelegate?.addNewCategory()
        }
        let index = indexPath.row
        dropdownDelegate?.newOptionIsSelected(for: type, at: index)
        selectedOptionIndex = index
        reloadData()
    }
}
