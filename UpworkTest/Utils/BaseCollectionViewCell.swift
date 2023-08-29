import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                didSelect()
            } else {
                didDeselect()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
        configureBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {}
    func setupUI() {}
    func configureBindings() {}
    func didSelect() {}
    func didDeselect() {}
}
