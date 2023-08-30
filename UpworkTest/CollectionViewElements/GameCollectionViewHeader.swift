import UIKit

class GameCollectionViewHeader: BaseCollectionReusableView {
    private let titleLabel = UILabel()
    private let containerView = UIView()
    private let frontContainerView = UIView()
    private let badgeImageView = UIImageView()
    
    func configure(
        with text: String
    ) {
        titleLabel.text = text
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        containerView.addSubview(frontContainerView)
        frontContainerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6)
        }
        
        containerView.addSubview(badgeImageView)
        badgeImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalTo(snp.leading)
            $0.width.equalTo(badgeImageView.snp.height)
        }
        
        frontContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setupUI() {
        backgroundColor = .clear
        
        containerView.layer.cornerRadius = 10
        frontContainerView.layer.cornerRadius = 10
        
        frontContainerView.backgroundColor = .yellow
        containerView.backgroundColor = .systemYellow
        badgeImageView.image = UIImage(named: "unit_icon")
    }
}
