import UIKit

class RoundedCollectionBottomView: BaseCollectionReusableView {
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
            $0.trailing.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(-4)
            $0.bottom.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
            $0.edges.equalToSuperview()
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
    private var borderWidth: CGFloat = 4
    private var borderLayer: CAShapeLayer? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(insetView)
        insetView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.trailing.equalToSuperview()
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
        let layoutAttributes = layoutAttributes as? DecorationCollectionViewLayoutAttributes
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

// Not in use
class RoundedCollectionBubbledView: BaseCollectionReusableView {
    private var insetView = UIView()

    private var bubbleLayer: CAShapeLayer? = nil
    
    override func prepareForReuse() {
        bubbleLayer?.removeFromSuperlayer()
        bubbleLayer = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(insetView)
        insetView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.trailing.equalToSuperview()
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
    
    private func drowBorder() {
        let overlayPath = UIBezierPath(roundedRect: insetView.frame, cornerRadius: 12)
        for _ in 0...10 {
            overlayPath.append(generateRandomBubblePath(in: insetView.frame))
        }

        let color = UIColor(white: 1, alpha: Double.random(in: 0.2...0.5))
        let fillLayer = CAShapeLayer()
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = color.cgColor
        insetView.layer.addSublayer(fillLayer)
    }
    
    private func generateRandomBubblePath(in rect: CGRect) -> UIBezierPath {
        let bubbleWidth = CGFloat.random(in: 30...60)
        let bubbleHeight = CGFloat.random(in: 20...30)
        
        let bubbleX = CGFloat.random(in: rect.origin.x+bubbleWidth...rect.origin.x+rect.width-bubbleWidth)
        let bubbleY = CGFloat.random(in: rect.origin.y+bubbleHeight...rect.origin.y+rect.height-bubbleHeight)
        
        let bubbleRect = CGRect(x: bubbleX, y: bubbleY, width: bubbleWidth, height: bubbleHeight)
        
        let bubblePath = UIBezierPath(roundedRect: bubbleRect, cornerRadius: 10)
        return bubblePath
    }
}
