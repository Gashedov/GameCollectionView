import UIKit

class GameCollectionViewHeader: UICollectionReusableView, ReuseIdentifiable {
    private let titleLabel = UILabel()
    private let containerView = UIView()
    private let frontContainerView = UIView()
    private let badgeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        with text: String
    ) {
        titleLabel.text = text
    }
    
    private func setupConstraints() {
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
    
    private func setupUI() {
        backgroundColor = .clear
        
        containerView.layer.cornerRadius = 10
        frontContainerView.layer.cornerRadius = 10
        
        titleLabel.textColor = UIColor(hex: "#b96b30")
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        frontContainerView.backgroundColor = UIColor(hex: "#f4df65")
        containerView.backgroundColor = UIColor(hex: "#e1ae52")
        badgeImageView.image = UIImage(named: "unit_icon")
    }
}
