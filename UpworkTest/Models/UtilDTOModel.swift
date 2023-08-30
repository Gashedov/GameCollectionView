import Foundation

struct UnitDTOModel: Decodable {
    let id: String?
    let labelar: String
    let labelen: String
    let desc: String
    let config: UnitDTOConfigModel
    let activities: [UnitActivityDTOModel]
    let finished: Bool
}

struct UnitDTOConfigModel: Decodable {
    let bgcolor: String
    let bordercolor: String
    let shadecolor: String
    let randoms: [String]
    
    var fillerImageName: String {
        randoms[Int.random(in: 0..<randoms.count)]
    }
}

struct UnitActivityDTOModel: Decodable {
    let id: String?
    let title: String
    let desc: String
    let type: String
    let stepid: String?
    let order: String?
    let status: String
    
    var imageName: String {
        "\(type)_token_\(status)"
    }
}
