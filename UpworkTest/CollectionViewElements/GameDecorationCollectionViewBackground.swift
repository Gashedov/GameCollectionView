import UIKit

class RoundedCollectionBackgroundView: BaseCollectionReusableView {
    private var insetView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
}

class RoundedCollectionBorderView: BaseCollectionReusableView {
    private var insetView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
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
            $0.bottom.trailing.equalToSuperview().offset(4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
