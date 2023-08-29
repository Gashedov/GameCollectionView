import Foundation
import UIKit

class InvertedStackLayout: UICollectionViewLayout {
    var cellSize: CGFloat = 100
    var sectionsInsets = UIEdgeInsets()
    var sectionsOffset: CGFloat = 20
    var headerInsets = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    
    var itemsPerRow: Int {
        Int(collectionViewContentSize.width/cellSize)
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            var height: CGFloat = 0.0
            let bounds = collectionView?.bounds ?? .zero
            let itemsPerRow = Int(bounds.width/cellSize)

            if let collectionView = collectionView {
                for section in 0 ..< collectionView.numberOfSections {
                    var sectionHeight: CGFloat = 0
                    if let headerAttr = layoutAttributesForDecorationView(
                        ofKind: UICollectionView.elementKindSectionHeader,
                        at: IndexPath(item: 0, section: section)
                    ) {
                        sectionHeight += headerAttr.frame.height
                    }
                    if let numItems = numberOfItemsInSection(section) {
                        sectionHeight += CGFloat(numItems/itemsPerRow) * cellSize
                    }
                    
                    sectionHeight += sectionsInsets.bottom + sectionsInsets.top
                    sectionHeight += sectionsOffset
                    
                    height += sectionHeight
                }
            }
            return CGSize(
                width: CGFloat(itemsPerRow)*cellSize,
                height: max(height, bounds.height)
            )
        }
    }

    override func prepare() {
        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = [UICollectionViewLayoutAttributes]()

        if let collectionView = self.collectionView {
            for section in 0 ..< collectionView.numberOfSections {
                if let headerAttr = layoutAttributesForSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    at: IndexPath(item: 0, section: section)
                ) {
                    layoutAttrs.append(headerAttr)
                }

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
        
        var sectionStartY = yPositionForSection(indexPath.section)
        
        if let headerAttr = layoutAttributesForSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: indexPath.section)
        ) {
            sectionStartY += headerAttr.frame.height + headerInsets.bottom
        }
        

        layoutAttr.frame = CGRect(
            x: xPosition,
            y: sectionStartY + CGFloat(row) * cellSize,
            width: cellSize,
            height: cellSize
        )

        return layoutAttr
    }
    
    override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        let sectionStartY = yPositionForSection(indexPath.section)
        
        let headerY = sectionStartY - headerInsets.top
        let headerX = (collectionView?.bounds.width ?? 0)/2 - 160 // add insets
        
        attributes.frame = CGRect(x: headerX, y: headerY, width: 320, height: 50)

        return attributes
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

extension InvertedStackLayout {
    private func yPositionForSection(_ section: Int) -> CGFloat {
        var yPosition: CGFloat = 0
        for index in 0..<section {
            yPosition += fullHeightOfSection(index)
        }
        return yPosition
    }
    
    private func numberOfItemsInSection(_ section: Int) -> Int? {
        guard let collectionView = self.collectionView,
              let numSectionItems = collectionView.dataSource?.collectionView(
                collectionView,
                numberOfItemsInSection: section
              ) else { return 0 }
        return numSectionItems
    }
    
    private func fullHeightOfSection(_ section: Int) -> CGFloat {
        var height: CGFloat = 0
        if let headerAttr = layoutAttributesForSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: section)
        ) {
            height += headerAttr.frame.height
            height += headerInsets.top + headerInsets.bottom
        }
        if let numItems = numberOfItemsInSection(section) {
            var numberOfRows = numItems/itemsPerRow
            if numItems%itemsPerRow != 0 {
                numberOfRows += 1
            }
            height += CGFloat(numberOfRows) * cellSize
        }
        
        height += sectionsInsets.bottom + sectionsInsets.top
        height += sectionsOffset
        
        return height
    }
}

