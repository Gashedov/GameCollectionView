import Foundation

class ViewModel {
    var units: [UnitModel] = []
    var mascot: MascotModel? = nil
    
    weak var delegate: ViewModelDelegate?
    
    func loadData(_ itemsPerRow: Int) {
        guard let data = loadJson(filename: "data") else { return }
    
        self.mascot = MascotModel(animationUrlString: data.mascot.url)
        let unitsDTOsWithActiveActivity = setupActiveActivity(in: data.units)
        let units = parseUnits(unitsDTOsWithActiveActivity)
        self.units = fillEmptySpaces(from: units, for: itemsPerRow)
        delegate?.dataDidLoad()
    }
    
    private func fillEmptySpaces(from data: [UnitModel], for itemsPerRow: Int) -> [UnitModel] {
        return data.map { unit in
            var fillersCount = 0
            let activitiesCount = unit.activities.count
            if activitiesCount%itemsPerRow != 0 {
                fillersCount = itemsPerRow - activitiesCount%itemsPerRow - 1
            } else {
                return unit
            }
            
            var fillers: [UnitActivityModel] = []
            for _ in 0...fillersCount {
                let randoms = unit.config.randoms
                fillers.append(.init(
                    title: "",
                    description: "",
                    type: "filler",
                    status: "",
                    imageName: randoms[Int.random(in: 0..<randoms.count)]
                ))
            }
            
            var newUnit = unit
            newUnit.activities = unit.activities + fillers
            return newUnit
        }
    }
    
    private func setupActiveActivity(in units: [UnitDTOModel]) -> [UnitDTOModel] {
        var isPreviousUnitFinished = true
        return units.map { unit in
            guard !unit.finished, isPreviousUnitFinished else { return unit }
            isPreviousUnitFinished = false
            
            var isPreviousActivityFinished = true
            var newUnit = unit
            newUnit.activities = unit.activities.map { activity in
                guard isPreviousActivityFinished, activity.status == "inactive" else {
                    return activity
                }
                isPreviousActivityFinished = false
                var newActivity = activity
                newActivity.status = "active"
                return newActivity
            }
            return newUnit
        }
    }
    
    private func parseUnits(_ units: [UnitDTOModel]) -> [UnitModel] {
        units.map { unitDTO in
            let config = UnitConfigModel(
                    backgroundColor: unitDTO.config.bgcolor,
                    borderColor: unitDTO.config.bordercolor,
                    shadeColor: unitDTO.config.shadecolor,
                    randoms: unitDTO.config.randoms
                )
            let activities = unitDTO.activities.map { activityDTO in
                var imageName = "\(activityDTO.type)_token_\(activityDTO.status)"
                if activityDTO.type == "convo" {
                    imageName = "ai_token_\(activityDTO.status)"
                } else if activityDTO.type == "eset" {
                    imageName = "exercise_token_\(activityDTO.status)"
                }
                return UnitActivityModel(
                    title: activityDTO.title,
                    description: activityDTO.desc,
                    type: activityDTO.type,
                    status: activityDTO.status,
                    imageName: imageName
                )
            }
            return UnitModel(
                label: unitDTO.labelen,
                config: config,
                activities: activities,
                finished: unitDTO.finished
            )
        }
    }
    
    private func createFiller(randomList: [String]) -> UnitActivityDTOModel {
        return .init(
            id: nil,
            title: "",
            desc: "",
            type: "filler",
            stepid: nil,
            order: nil,
            status: "inactive"
        )
    }
    
    private func loadJson(filename fileName: String) -> DataDTOModel? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(DataResponseDTOModel.self, from: data)
                return jsonData.data
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}

protocol ViewModelDelegate: AnyObject {
    func dataDidLoad()
}
