import Foundation

struct DataResponseDTOModel: Decodable {
    let data: DataDTOModel
}
struct DataDTOModel: Decodable {
    let units: [UnitDTOModel]
}
