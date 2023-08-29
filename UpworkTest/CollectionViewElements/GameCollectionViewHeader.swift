import UIKit

class GameCollectionViewHeader: BaseCollectionReusableView {
    private let titleLabel = UILabel()
    private let containerView = UIView()
    private let frontContainerView = UIView()
    private let badgeImageView = UIImageView()
    
    func configure(with text: String, and color: UIColor) {
        titleLabel.text = text
        //frontContainerView.backgroundColor = color
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        containerView.addSubview(frontContainerView)
        frontContainerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6)
        }
        
        containerView.addSubview(badgeImageView)
        badgeImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        frontContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setupUI() {
        backgroundColor = .clear
        
        containerView.backgroundColor = .gray
        containerView.layer.cornerRadius = 10
        frontContainerView.backgroundColor = .lightGray
        frontContainerView.layer.cornerRadius = 10
        titleLabel.text = "Title"
        badgeImageView.image = .checkmark
    }
}
