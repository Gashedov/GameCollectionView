import Foundation

struct UnitDTOModel: Decodable {
    let id: String?
    let labelar: String
    let labelen: String
    let desc: String
    let config: UnitDTOConfigModel
    var activities: [UnitActivityDTOModel]
    let finished: Bool
}

struct UnitDTOConfigModel: Decodable {
    let bgcolor: String
    let bordercolor: String
    let shadecolor: String
    let randoms: [String]
}

struct UnitActivityDTOModel: Decodable {
    let id: String?
    let title: String
    let desc: String
    let type: String
    let stepid: String?
    let order: String?
    var status: String
}
