import Foundation
import UIKit

class InvertedStackLayout: UICollectionViewLayout {
    let cellSize: CGFloat = 100
    
    var itemsPerRow: Int {
        Int(collectionViewContentSize.width/cellSize)
    }

    override func prepare() {
        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = [UICollectionViewLayoutAttributes]()

        if let collectionView = self.collectionView {
            for section in 0 ..< collectionView.numberOfSections {
                if let numberOfSectionItems = numberOfItemsInSection(section) {
                    for item in 0 ..< numberOfSectionItems {
                        let indexPath = IndexPath(item: item, section: section)
                        let layoutAttr = layoutAttributesForItem(at: indexPath)

                        if let layoutAttr = layoutAttr, layoutAttr.frame.intersects(rect) {
                            layoutAttrs.append(layoutAttr)
                        }
                    }
                }
            }
        }

        return layoutAttrs
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let contentSize = self.collectionViewContentSize
    
        let row = indexPath.item/itemsPerRow
        let rowPosition = indexPath.item - row*itemsPerRow
        
        
        var xPosition = CGFloat(rowPosition) * cellSize
        if row%2 != 0 {
            xPosition = contentSize.width - xPosition - cellSize
        }

        layoutAttr.frame = CGRect(
            x: xPosition,
            y: CGFloat(row) * cellSize,
            width: cellSize,
            height: cellSize
        )

        return layoutAttr
    }

    func numberOfItemsInSection(_ section: Int) -> Int? {
        if let collectionView = self.collectionView,
            let numSectionItems = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section)
        {
            return numSectionItems
        }

        return 0
    }

    override var collectionViewContentSize: CGSize {
        get {
            var height: CGFloat = 0.0
            var bounds = CGRect.zero

            if let collectionView = self.collectionView {
                for section in 0 ..< collectionView.numberOfSections {
                    if let numItems = numberOfItemsInSection(section) {
                        height += CGFloat(numItems) * cellSize
                    }
                }

                bounds = collectionView.bounds
            }
            
            let itemsPerRow = Int(bounds.width/cellSize)

            return CGSize(width: CGFloat(itemsPerRow)*cellSize, height: max(height, bounds.height))
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = self.collectionView?.bounds,
            oldBounds.width != newBounds.width || oldBounds.height != newBounds.height
        {
            return true
        }

        return false
    }
}

