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
    
    override func prepareForReuse() {
        startLineView.removeFromSuperview()
        endLineView.removeFromSuperview()
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
    
    func layoutHorizontalLines() {
        layoutBeginLine()
        layoutEndLine()
    }
    
    func layoutLeftDownLines() {
        layoutBeginLine()
        layoutBottomLine()
    }
    
    func layoutRightDownLines() {
        startLineView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
        layoutBottomLine()
    }
    
    func layoutTopLeftLines() {
        layoutTopLine()
        endLineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    func layoutTopRightLines() {
        layoutTopLine()
        layoutEndLine()
    }
    
    func layoutBeginLine() {
        startLineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    func layoutEndLine() {
        endLineView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    func layoutTopLine() {
        startLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(4)
        }
    }
    
    func layoutBottomLine() {
        endLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(4)
        }
    }
}
