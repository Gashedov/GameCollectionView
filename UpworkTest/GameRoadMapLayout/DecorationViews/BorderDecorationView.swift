import UIKit

class BorderDecorationView: UICollectionReusableView, ReuseIdentifiable {
    private var insetView = UIView()
    
    private var borderColor: UIColor? = nil
    private var borderWidth: CGFloat = 4
    private var borderLayer: CAShapeLayer? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(insetView)
        insetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        isUserInteractionEnabled = false
        insetView.isUserInteractionEnabled = false
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
        let layoutAttributes = layoutAttributes as? BorderDecorationCollectionViewLayoutAttribute
        borderColor = layoutAttributes?.color
        borderWidth = layoutAttributes?.borderWidth ?? 4
    }
    
    private func drowBorder() {
        borderLayer?.removeFromSuperlayer()
        borderLayer = nil
        
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
