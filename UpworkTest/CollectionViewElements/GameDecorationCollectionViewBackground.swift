import UIKit

class RoundedCollectionBackgroundView: BaseCollectionReusableView {
    private var insetView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(insetView)
        insetView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(-4)
            $0.trailing.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let scLayoutAttributes = layoutAttributes as? DecorationCollectionViewLayoutAttributes
        insetView.backgroundColor = scLayoutAttributes?.color
    }
}

class RoundedCollectionBorderView: BaseCollectionReusableView {
    private var insetView = UIView()
    
    private var borderColor: UIColor? = nil
    private var borderLayer: CAShapeLayer? = nil
    
    override func prepareForReuse() {
        borderColor = nil
        borderLayer?.removeFromSuperlayer()
        borderLayer = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(insetView)
        insetView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.trailing.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drowBorder()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let layoutAttributes = layoutAttributes as? DecorationCollectionViewLayoutAttributes
        borderColor = layoutAttributes?.color
    }
    
    private func drowBorder() {
        let borderWidth: CGFloat = 4
        let transparentSize = CGSize(
            width: insetView.frame.size.width-(borderWidth*2),
            height: insetView.frame.size.height-(borderWidth*2)
        )
        let transparentOrigin = CGPoint(
            x: insetView.frame.origin.x+borderWidth,
            y: insetView.frame.origin.y+borderWidth
        )
        let transparentRect = CGRect(origin: transparentOrigin, size: transparentSize)
        
        let overlayPath = UIBezierPath(roundedRect: insetView.frame, cornerRadius: 12)
        let transparentPath = UIBezierPath(roundedRect: transparentRect, cornerRadius: 12)
        overlayPath.append(transparentPath)
        overlayPath.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = borderColor?.cgColor
        insetView.layer.addSublayer(fillLayer)
        borderLayer = fillLayer
    }
}
