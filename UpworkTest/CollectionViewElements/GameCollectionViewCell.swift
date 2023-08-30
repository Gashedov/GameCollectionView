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
    case up
}

class GameCollectionViewCell: BaseCollectionViewCell {
    private let badgeImageView = UIImageView()
    private let startLineImageView = UIImageView()
    
    private let startLineView = UIView()
    private let endLineView = UIView()
    
    override func prepareForReuse() {
        startLineView.removeFromSuperview()
        startLineView.snp.removeConstraints()
        endLineView.removeFromSuperview()
        endLineView.snp.removeConstraints()
        
        startLineImageView.isHidden = true
        
        backgroundColor = .clear
    }
    
    override func setupConstraints() {
        addSubview(badgeImageView)
        badgeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        addSubview(startLineImageView)
        startLineImageView.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.equalTo(12)
        }
    }
    
    override func setupUI() {
        backgroundColor = .green
        
        startLineView.backgroundColor = .white
        endLineView.backgroundColor = .white
    
        startLineImageView.image = UIImage(named: "start_line")
        startLineImageView.isHidden = true
    }
    
    func configure(
        badgeImageName: String,
        primaryColorHEX: String
    ) {
        badgeImageView.image = UIImage(named: badgeImageName)
        let alpha = Double.random(in: 0.7...1.0)
        backgroundColor = UIColor(hex: primaryColorHEX, alpha: alpha)
    }
    
    func configureStartImage(visible: Bool) {
        startLineImageView.isHidden = !visible
    }
    
    func configureLine(lineTipe: LineType) {
        insertSubview(startLineView, belowSubview: badgeImageView)
        insertSubview(endLineView, belowSubview: badgeImageView)
        
        switch lineTipe {
        case .horizantal: layoutHorizontalLines()
        case .leftDown: layoutLeftDownLines()
        case .rightDown: layoutRightDownLines()
        case .topLeft: layoutTopLeftLines()
        case .topRight: layoutTopRightLines()
        case .begin: layoutEndLine()
        case .end: layoutBeginLine()
        case .up: layoutTopLine()
        }
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
