import UIKit

class ViewController: UIViewController {
    private let titleBackgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let layout = InvertedStackLayout()
    private lazy var gameCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleBackgroundImageView)
        titleBackgroundImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(40)
        }
        
        titleBackgroundImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.addSubview(gameCollectionView)
        gameCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleBackgroundImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        gameCollectionView.register(GameCollectionViewCell.self)
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        
        titleBackgroundImageView.backgroundColor = .orange
        titleLabel.text = "Title"
    }
}

extension ViewController: UICollectionViewDelegate {
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 100
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: indexPath.item)
        configureLines(cell: cell, at: indexPath)
        return cell
    }
    
    private func configureLines(cell: GameCollectionViewCell, at indexPath: IndexPath) {
        let isFirstInRow = indexPath.item%layout.itemsPerRow == 0
        let isLastInRow = indexPath.item%layout.itemsPerRow == layout.itemsPerRow-1
        let isInBackwardRow = (indexPath.item/layout.itemsPerRow)%2 != 0
        
        if indexPath.item == 0 {
            cell.configureLine(lineTipe: .begin)
        } else if indexPath.item == gameCollectionView.numberOfItems(inSection: 0) - 1 {
            if isInBackwardRow {
                cell.configureLine(lineTipe: .begin)
            } else {
                cell.configureLine(lineTipe: .end)
            }
        } else if isFirstInRow {
            if isInBackwardRow {
                cell.configureLine(lineTipe: .topLeft)
            } else {
                cell.configureLine(lineTipe: .topRight)
            }
        } else if isLastInRow {
            if isInBackwardRow {
                cell.configureLine(lineTipe: .rightDown)
            } else {
                cell.configureLine(lineTipe: .leftDown)
            }
        }
        else {
            cell.configureLine(lineTipe: .horizantal)
        }
    }
}
