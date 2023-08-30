import UIKit

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    
    private let layout = GameRoadMapLayout()
    private lazy var gameCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        view.addSubview(gameCollectionView)
        gameCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        gameCollectionView.register(GameCollectionViewCell.self)
        gameCollectionView.registerHeader(GameCollectionViewHeader.self)
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        
        gameCollectionView.showsVerticalScrollIndicator = false
        gameCollectionView.showsHorizontalScrollIndicator = false
        
        gameCollectionView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let itemsPerRow = Int(gameCollectionView.frame.width/layout.cellSize)
        viewModel.loadData(itemsPerRow)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard indexPath.section < viewModel.units.count,
              indexPath.item < viewModel.units[indexPath.section].activities.count else { return }
        
        let model = viewModel.units[indexPath.section].activities[indexPath.item]
        switch model.type {
        case "lsn": print("items selected \(model.type)")
        case "book": print("items selected \(model.type)")
        case "video": print("items selected \(model.type)")
        case "ai": print("items selected \(model.type)")
        case "game": print("items selected \(model.type)")
        case "exercise": print("items selected \(model.type)")
        default:
            break
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.units.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard section < viewModel.units.count else {
            return 0
        }
        return viewModel.units[section].activities.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header: GameCollectionViewHeader = collectionView.dequeueReusableHeaderView(for: indexPath)
        guard indexPath.section < viewModel.units.count else {
            return header
        }
        
        let model = viewModel.units[indexPath.section]
        header.configure(with: model.label)
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        guard indexPath.section < viewModel.units.count,
              indexPath.item < viewModel.units[indexPath.section].activities.count else {
            return cell
        }
        
        let config = viewModel.units[indexPath.section].config
        let model = viewModel.units[indexPath.section].activities[indexPath.item]
        
        cell.configure(badgeImageName: model.imageName, primaryColorHEX: config.backgroundColor)
        configureLines(cell: cell, at: indexPath)
        
        if indexPath.item == 0 {
            cell.configureStartImage(visible: true)
        }
        
        return cell
    }
    
    private func configureLines(cell: GameCollectionViewCell, at indexPath: IndexPath) {
        guard indexPath.section < viewModel.units.count,
              indexPath.item < viewModel.units[indexPath.section].activities.count
        else { return }
        
        if viewModel.units[indexPath.section].activities[indexPath.item].type == "filler" {
            return
        }
        
        var isLast = indexPath.item == gameCollectionView.numberOfItems(inSection: indexPath.section) - 1
        
        if indexPath.item+1 < viewModel.units[indexPath.section].activities.count,
           viewModel.units[indexPath.section].activities[indexPath.item+1].type == "filler" {
            isLast = true
        }
        
        let isFirstInRow = indexPath.item%layout.itemsPerRow == 0
        let isLastInRow = indexPath.item%layout.itemsPerRow == layout.itemsPerRow-1
        let isInBackwardRow = (indexPath.item/layout.itemsPerRow)%2 != 0
        
        var lineDerection: LineType
        if indexPath.item == 0 {
            lineDerection = .begin
        } else if isLast {
            if isInBackwardRow {
                if isFirstInRow {
                    lineDerection = .up
                } else {
                    lineDerection = .begin
                }
            } else {
                if isFirstInRow {
                    lineDerection = .up
                } else {
                    lineDerection = .end
                }
            }
        } else if isFirstInRow {
            if isInBackwardRow {
                lineDerection = .topLeft
            } else {
                lineDerection = .topRight
            }
        } else if isLastInRow {
            if isInBackwardRow {
                lineDerection = .rightDown
            } else {
                lineDerection = .leftDown
            }
        }
        else {
            lineDerection = .horizantal
        }
       cell.configureLine(lineTipe: lineDerection)
    }
}

extension ViewController: ViewModelDelegate {
    func dataDidLoad() {
        layout.sectionsColors = viewModel.units.map { unit in
            (
                borderColor: UIColor(hex: unit.config.borderColor) ,
                shadeColor: UIColor(hex: unit.config.shadeColor)
            )
        }
        gameCollectionView.reloadData()
    }
}
