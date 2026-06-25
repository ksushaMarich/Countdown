
import UIKit

class CalendarFlowLayout: UICollectionViewFlowLayout {

    init(inset: CGFloat, scrollDirection: UICollectionView.ScrollDirection, leadingInset: CGFloat = 0) {
        super.init()
        minimumLineSpacing = inset
        minimumInteritemSpacing = inset
        self.scrollDirection = scrollDirection

        switch scrollDirection {
        case .horizontal:
            sectionInset = UIEdgeInsets(top: 0, left: leadingInset, bottom: 0, right: 0)
        case .vertical:
            sectionInset = UIEdgeInsets(top: leadingInset, left: 0, bottom: 0, right: 0)
        @unknown default:
            break
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



