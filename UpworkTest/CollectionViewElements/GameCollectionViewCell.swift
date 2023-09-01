import UIKit
import SnapKit
import RiveRuntime

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

class GameCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    enum CellType {
        case activity(String)
        case filler(String)
    }
    private let badgeImageView = UIImageView()
    private let startLineImageView = UIImageView()
    
    private let startLineView = UIView()
    private let endLineView = UIView()
    
    var animationView: RiveRuntime.RiveView? = nil
    var animationModel: RiveViewModel? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        startLineView.removeFromSuperview()
        startLineView.snp.removeConstraints()
        endLineView.removeFromSuperview()
        endLineView.snp.removeConstraints()
        
        startLineImageView.isHidden = true
        
        backgroundColor = .clear
        
        animationView?.snp.removeConstraints()
        animationView?.removeFromSuperview()
        animationView = nil
        animationModel = nil
    }
    
    private func setupConstraints() {
        addSubview(startLineImageView)
        startLineImageView.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.equalTo(12)
        }
        
        addSubview(badgeImageView)
        badgeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
    private func setupUI() {
        backgroundColor = .green
        
        startLineView.backgroundColor = .white
        startLineView.alpha = 0.6
        endLineView.backgroundColor = .white
        endLineView.alpha = 0.6
    
        startLineImageView.image = UIImage(named: "start_line")
        startLineImageView.isHidden = true
        
        
        endLineView.layer.shadowColor = UIColor.white.cgColor
        endLineView.layer.shadowOpacity = 1
        endLineView.layer.shadowOffset = .zero
        endLineView.layer.shadowRadius = 10
        endLineView.layer.shouldRasterize = true

        startLineView.layer.shadowColor = UIColor.white.cgColor
        startLineView.layer.shadowOpacity = 1
        startLineView.layer.shadowOffset = .zero
        startLineView.layer.shadowRadius = 10
        startLineView.layer.shouldRasterize = true
    }
    
    func configure(
        cellType: CellType,
        primaryColorHEX: String
    ) {
        var image: UIImage?
        switch cellType {
        case .activity(let imageName):
            image = UIImage(named: imageName)
            badgeImageView.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(18)
            }
        case .filler(let imageName):
            image = UIImage(named: imageName)
            badgeImageView.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(6)
            }
        }
        badgeImageView.image = image
        let alpha = Double.random(in: 0.3...0.9)
        backgroundColor = UIColor(hex: primaryColorHEX, alpha: alpha)
    }
    
    func addAnimation(
        withUrlString urlString: String?,
        isInBackwardRow: Bool
    ) {
        guard let urlString else { return }
        let model = RiveViewModel(webURL: urlString)
        let view = model.createRiveView()
        
        view.isUserInteractionEnabled = false
        
        addSubview(view)
        
        view.snp.makeConstraints {
            if isInBackwardRow {
                $0.trailing.equalTo(badgeImageView.snp.centerX)
                $0.leading.equalToSuperview().offset(-20)
            } else {
                $0.trailing.equalToSuperview().offset(20)
                $0.leading.equalTo(badgeImageView.snp.centerX)
            }
            
            $0.top.equalToSuperview().offset(-20)
            $0.bottom.equalTo(badgeImageView).offset(14)
        }
        
        animationView = view
        animationModel = model
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
            $0.height.equalTo(8)
        }
        layoutBottomLine()
    }
    
    private func layoutTopLeftLines() {
        layoutTopLine()
        endLineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
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
            $0.height.equalTo(8)
        }
    }
    
    private func layoutEndLine() {
        endLineView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
    
    private func layoutTopLine() {
        startLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(8)
        }
    }
    
    private func layoutBottomLine() {
        endLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(8)
        }
    }
}
