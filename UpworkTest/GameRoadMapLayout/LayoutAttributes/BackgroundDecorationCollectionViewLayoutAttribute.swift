import UIKit

class BackgroundDecorationCollectionViewLayoutAttribute: UICollectionViewLayoutAttributes {
    var color: UIColor? = .white
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? BackgroundDecorationCollectionViewLayoutAttribute
        copy?.color = self.color
        return copy as Any
    }
}
