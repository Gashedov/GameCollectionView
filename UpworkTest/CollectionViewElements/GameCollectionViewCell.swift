import UIKit
import SnapKit

enum LineType {
    case horizantal
    case leftDown
    case rightDown
    case topLeft
    case topRight
    case begin
    case end
}

class GameCollectionViewCell: BaseCollectionViewCell {
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    private let startLineView = UIView()
    private let endLineView = UIView()
    
    private var containerLayer: CALayer?
    
    override func prepareForReuse() {
        startLineView.removeFromSuperview()
        endLineView.removeFromSuperview()
        
        backgroundColor = .gray
        containerLayer?.mask = nil
    }
    
    override func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupUI() {
        backgroundColor = .gray
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        startLineView.backgroundColor = .red
        endLineView.backgroundColor = .red
    
    }
    
    func configure(with number: Int) {
        titleLabel.text = String(number)
    }
    
    func configureLine(lineTipe: LineType) {
        insertSubview(startLineView, belowSubview: titleLabel)
        insertSubview(endLineView, belowSubview: titleLabel)
        
        switch lineTipe {
        case .horizantal: layoutHorizontalLines()
        case .leftDown: layoutLeftDownLines()
        case .rightDown: layoutRightDownLines()
        case .topLeft: layoutTopLeftLines()
        case .topRight: layoutTopRightLines()
        case .begin: layoutEndLine()
        case .end: layoutBeginLine()
            
        }
    }
    
    func roundCorners(corners: UIRectCorner) {
        roundCorners(corners: corners, radius: 12)
    }
    
    private func layoutHorizontalLines() {
        layoutBeginLine()
        layoutEndLine()
    }
    
    private func layoutLeftDownLines() {
        layoutBeginLine()
        layoutBottomLine()
    }
    
    private func layoutRightDownLines() {
        startLineView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
        layoutBottomLine()
    }
    
    private func layoutTopLeftLines() {
        layoutTopLine()
        endLineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    private func layoutTopRightLines() {
        layoutTopLine()
        layoutEndLine()
    }
    
    private func layoutBeginLine() {
        startLineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    private func layoutEndLine() {
        endLineView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    private func layoutTopLine() {
        startLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(4)
        }
    }
    
    private func layoutBottomLine() {
        endLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(4)
        }
    }
}
extension GameCollectionViewCell {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        let containerLayer = self.containerLayer ?? CALayer()
        
        containerLayer.backgroundColor = layer.backgroundColor
        containerLayer.frame = bounds
        containerLayer.mask = maskLayer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.insertSublayer(containerLayer, at: 0)
        
        self.containerLayer = containerLayer
    }
}
