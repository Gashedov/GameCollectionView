import UIKit

class RoundedBackgroundDecorationView: UICollectionReusableView, ReuseIdentifiable {
    private var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(-4)
            $0.bottom.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
        }
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let scLayoutAttributes = layoutAttributes as? BackgroundDecorationCollectionViewLayoutAttribute
        backgroundView.backgroundColor = scLayoutAttributes?.color
    }
}
