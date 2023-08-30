import Foundation

struct UnitModel: Decodable {
    let label: String
    let config: UnitConfigModel
    var activities: [UnitActivityModel]
    let finished: Bool
}

struct UnitConfigModel: Decodable {
    let backgroundColor: String
    let borderColor: String
    let shadeColor: String
    let randoms: [String]
}

struct UnitActivityModel: Decodable {
    let title: String
    let description: String
    let type: String
    let status: String
    let imageName: String
}
