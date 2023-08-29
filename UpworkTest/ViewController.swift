import UIKit

class ViewController: UIViewController {
    private let layout = InvertedStackLayout()
    private lazy var gameCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(gameCollectionView)
        gameCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        gameCollectionView.register(GameCollectionViewCell.self)
        gameCollectionView.registerHeader(GameCollectionViewHeader.self)
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
    }
}

extension ViewController: UICollectionViewDelegate {
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let count = 20
        let itemsPerRow = Int(collectionView.frame.width/layout.cellSize)
        if count%itemsPerRow != 0 {
            return count + (itemsPerRow - count%itemsPerRow)
        }
        return count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header: GameCollectionViewHeader = collectionView.dequeueReusableHeaderView(for: indexPath)
        header.configure(with: "Title number \(indexPath.section)", and: .lightGray)
        //supplementaryView.backgroundColor = UIColor.blueColor()
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: indexPath.item)
        configureLines(cell: cell, at: indexPath)
        configureCorners(cell: cell, at: indexPath)
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
    
    private func configureCorners(cell: GameCollectionViewCell, at indexPath: IndexPath) {
        if indexPath.item == 0 {
            cell.configureLine(lineTipe: .begin)
        } else if indexPath.item == gameCollectionView.numberOfItems(inSection: 0) - 1 {
            
        } else {
            
        }
    }
}
