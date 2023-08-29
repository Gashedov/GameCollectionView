import UIKit

import UIKit

protocol ReuseIdentifiable {
    static var reuseId: String { get }
}

extension ReuseIdentifiable where Self: UIView {
    static var reuseId: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReuseIdentifiable {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseId)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReuseIdentifiable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseId) at indexPath: \(indexPath)")
        }
        return cell
    }
    
    func registerFooter<T: UICollectionReusableView>(_: T.Type) where T: ReuseIdentifiable {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.reuseId
        )
    }
    
    func registerHeader<T: UICollectionReusableView>(_: T.Type) where T: ReuseIdentifiable {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reuseId
        )
    }

    func dequeueReusableFooterView<T: UICollectionReusableView>(
        for indexPath: IndexPath
    ) -> T where T: ReuseIdentifiable {
        guard let footer = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.reuseId,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue footer with identifier: \(T.reuseId)")
        }
        return footer
    }
    
    func dequeueReusableHeaderView<T: UICollectionReusableView>(
        for indexPath: IndexPath
    ) -> T where T: ReuseIdentifiable {
        guard let header = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reuseId,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue footer with identifier: \(T.reuseId)")
        }
        return header
    }
}
