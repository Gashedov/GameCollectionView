import UIKit

class BubbledDecorationView: UICollectionReusableView, ReuseIdentifiable {
    private var insetView = UIView()

    private var bubbleLayer: CALayer? = nil
    
    private var bubbleColor: UIColor? = nil
    private var chanks: [CGRect] = []

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
        drowBubbles()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let layoutAttributes = layoutAttributes as? BubbledDecorationCollectionViewLayoutAttribute else {
            return
        }
        bubbleColor = layoutAttributes.color
        chanks = calculateChunks(
            rowCount: layoutAttributes.rowsCount,
            itemsPerRow: layoutAttributes.itemsPerRow,
            itemSize: layoutAttributes.cellSize
        )
    }
    
    private func drowBubbles() {
        bubbleLayer?.removeFromSuperlayer()
        bubbleLayer = nil
        
        let bubbleLayer = CALayer()
        bubbleLayer.frame = insetView.frame
        
        for chunk in chanks {
            let path = generateRandomBubblePath(in: chunk)
            
            let color = bubbleColor?.withAlphaComponent(Double.random(in: 0.4...0.6))
            let fillLayer = CAShapeLayer()
            fillLayer.path = path.cgPath
            fillLayer.fillColor = color?.cgColor
            bubbleLayer.addSublayer(fillLayer)
        }
    
        insetView.layer.addSublayer(bubbleLayer)
        self.bubbleLayer = bubbleLayer
    }
    
    private func generateRandomBubblePath(in rect: CGRect) -> UIBezierPath {
        let bubbleHeight = CGFloat.random(in: 30...50)
        let bubbleWidth = CGFloat.random(in: bubbleHeight+10...bubbleHeight+30)
        
        let bubbleX = CGFloat.random(in: rect.origin.x+bubbleWidth...rect.origin.x+rect.width-bubbleWidth)
        let bubbleY = CGFloat.random(in: rect.origin.y+bubbleHeight...rect.origin.y+rect.height-bubbleHeight)
        
        let bubbleRect = CGRect(x: bubbleX, y: bubbleY, width: bubbleWidth, height: bubbleHeight)
        
        let bubblePath = UIBezierPath(roundedRect: bubbleRect, cornerRadius: 10)
        return bubblePath
    }
    
    private func calculateChunks(
        rowCount: Int,
        itemsPerRow: Int,
        itemSize: CGFloat
    ) -> [CGRect] {
        var result: [CGRect] = []
        
        var chunksRowCount = rowCount/2
        if rowCount%2 != 0 && rowCount > 1 {
            chunksRowCount += 1
        }
        
        let chunksColumnCount = itemsPerRow/2
        
        let chunkWidth = itemSize*CGFloat(itemsPerRow)/CGFloat(chunksColumnCount)
        let chunkHeight = itemSize*1.75
        
        for rowIndex in 0..<chunksRowCount {
            for clumnIndex in  0..<chunksColumnCount {
                result.append(
                    CGRect(
                        x: CGFloat(clumnIndex)*chunkWidth,
                        y: CGFloat(rowIndex)*itemSize*1.25,
                        width: chunkWidth,
                        height: chunkHeight
                    )
                )
            }
        }
        
        return result
    }
}
