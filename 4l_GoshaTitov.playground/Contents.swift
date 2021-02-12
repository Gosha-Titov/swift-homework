import UIKit

enum CarPart { case windows, doors }
enum StatusOfCarPart: String { case open = "open", close = "close" }
enum StatusOfEngine: String  { case on = "running", off = "off" }
enum KindOfTrailer: String {
    case tank = "tank"
    case container = "container"
    case flatbed = "flatbed"
    case refrigerated = "refrigerated"
}

class Car {
    let carBrand: String
    let releaseDate: Int
    let horsePower: Int
    var doorsStatus: StatusOfCarPart
    var windowsStatus: StatusOfCarPart
    var engineStatus: StatusOfEngine
    
    func changeStatus(of carPart: CarPart, to newStatus: StatusOfCarPart) {
        switch carPart {
        case .doors: doorsStatus = newStatus
        case .windows: windowsStatus = newStatus
        }
    }
    
    func turnEngineOn()  { engineStatus = .on }
    func turnEngineOff() { engineStatus = .off }
    
    func printGeneralInfo() {
        print("General informaiton about \(carBrand):")
        print("The car was released in \(releaseDate)")
        print("Horsepower = \(horsePower)")
    }
    
    func printDetailedInfo() {
        print("Detailed information about \(carBrand):")
        print("The doors are \(doorsStatus.rawValue)")
        print("The windows are \(windowsStatus.rawValue)")
        print("The engine is \(engineStatus.rawValue)")
    }
    
    init(carBrand: String, releaseDate: Int, horsePower: Int) {
        self.carBrand = carBrand
        self.releaseDate = releaseDate
        self.horsePower = horsePower
        
        self.doorsStatus = .close
        self.windowsStatus = .close
        self.engineStatus = .off
    }
}

class SportCar: Car {
    let maxSpeed: Int
    let weight: Int
    
    override func printGeneralInfo() {
        super.printGeneralInfo()
        print("Max speed = \(maxSpeed)")
        print("The car weights \(weight) kg")
    }
    
    init(carBrand: String, releaseDate: Int, horsePower: Int, maxSpeed: Int, weight: Int) {
        self.maxSpeed = maxSpeed
        self.weight = weight
        super.init(carBrand: carBrand, releaseDate: releaseDate, horsePower: horsePower)
    }
}

class TrunkCar: Car {
    var trailer: KindOfTrailer?
    var maxCargoWeight: Int?
    
    func hookUpTailer(trailer: KindOfTrailer, maxCargoWeight: Int) {
        guard self.trailer == nil else { return }
        self.trailer = trailer
        self.maxCargoWeight = maxCargoWeight
    }
    
    func unhookTrailer() {
        self.trailer = nil
        self.maxCargoWeight = nil
    }
    
    override func printGeneralInfo() {
        super.printGeneralInfo()
        if let trailer = trailer {
            print("There is a \(trailer.rawValue) trailer")
        }
        if let maxCargoWeight = maxCargoWeight {
            print("\(carBrand) can transport \(maxCargoWeight) kg")
        }
    }
    
    init(carBrand: String, releaseDate: Int, horsePower: Int, trailer: KindOfTrailer?, maxCargoWeight: Int?) {
        self.trailer = trailer
        self.maxCargoWeight = maxCargoWeight
        super.init(carBrand: carBrand, releaseDate: releaseDate, horsePower: horsePower)
    }
    
    override convenience init(carBrand: String, releaseDate: Int, horsePower: Int) {
        self.init(carBrand: carBrand, releaseDate: releaseDate, horsePower: horsePower, trailer: nil, maxCargoWeight: nil)
    }
}

var sportCar = SportCar(carBrand: "Porshe", releaseDate: 2015, horsePower: 550, maxSpeed: 280, weight: 2000)
sportCar.printGeneralInfo()
sportCar.turnEngineOn()
sportCar.changeStatus(of: .windows, to: .open)
print("")
sportCar.printDetailedInfo()

print("\n––––––––––––––––––––––––\n")

var trunkCar = TrunkCar(carBrand: "Volvo", releaseDate: 2021, horsePower: 700)
trunkCar.hookUpTailer(trailer: .container, maxCargoWeight: 30_000)
trunkCar.printGeneralInfo()
trunkCar.unhookTrailer()
trunkCar.changeStatus(of: .doors, to: .open)
print("")
trunkCar.printDetailedInfo()





