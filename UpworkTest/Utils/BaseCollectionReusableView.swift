import UIKit

class BaseCollectionReusableView: UICollectionReusableView, ReuseIdentifiable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {}
    func setupUI() {}
}
