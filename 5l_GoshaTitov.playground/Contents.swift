import UIKit

enum CarPart {
    case windows
    case doors
    case roof
}
enum StatusOfCarPart: String {
    case open  = "open"
    case close = "close"
}

enum StatusOfEngine: String  {
    case on  = "running"
    case off = "off"
}

enum KindOfTrailer: String {
    case tank = "tank"
    case container = "container"
    case flatbed = "flatbed"
    case refrigerated = "refrigerated"
}

// MARK: - Protocols

protocol Car: class {
    var carBrand: String { get }
    var releaseDate: Int { get }
    var horsePower:  Int { get }
    
    var doorsStatus:   StatusOfCarPart { get set }
    var windowsStatus: StatusOfCarPart { get set }
    var engineStatus:  StatusOfEngine  { get set }
    
    func changeStatusOfDoors(to: StatusOfCarPart)
    func changeStatusOfWindows(to: StatusOfCarPart)
    func changeStatusOfEngine(to: StatusOfEngine)
}

extension Car {
    func changeStatusOfDoors(to newStatus: StatusOfCarPart) {
        doorsStatus = newStatus
    }
    
    func changeStatusOfWindows(to newStatus: StatusOfCarPart) {
        windowsStatus = newStatus
    }
    
    func changeStatusOfEngine(to newStatus: StatusOfEngine) {
        engineStatus = newStatus
    }
}

// MARK: - Classes

class SportCar: Car, CustomStringConvertible {
    let carBrand: String
    let releaseDate: Int
    let horsePower: Int
    
    let maxSpeed: Int
    let weight: Int
    
    var doorsStatus: StatusOfCarPart
    var windowsStatus: StatusOfCarPart
    var engineStatus: StatusOfEngine
    var roofStatus: StatusOfCarPart
    
    var description: String {
        return """
        General information about \(carBrand):
        * The car was released in \(releaseDate)
        * Horsepower = \(horsePower)
        * Max speed = \(maxSpeed) km/h
        * Weight = \(weight) kg

        Detailed information about \(carBrand):
        # Doors are \(doorsStatus.rawValue)
        # Windows are \(windowsStatus.rawValue)
        # Roof is \(roofStatus.rawValue)
        # Engine is \(engineStatus.rawValue)\n
        """
    }
    
    func changeStatusOfRoof(to newStatus: StatusOfCarPart) {
        roofStatus = newStatus
    }
    
    init(carBrand: String, releaseDate: Int, horsePower: Int, maxSpeed: Int, weight: Int) {
        self.carBrand = carBrand
        self.releaseDate = releaseDate
        self.horsePower = horsePower
        
        self.doorsStatus = .close
        self.windowsStatus = .close
        self.roofStatus = .close
        self.engineStatus = .off
        
        self.maxSpeed = maxSpeed
        self.weight = weight
    }
}

class TrunkCar: Car, CustomStringConvertible {
    let carBrand: String
    let releaseDate: Int
    let horsePower: Int
    
    var doorsStatus: StatusOfCarPart
    var windowsStatus: StatusOfCarPart
    var engineStatus: StatusOfEngine
    
    var trailer: KindOfTrailer?
    var maxCargoWeight: Int?
    
    var description: String {
        var result: String = """
        General information about \(carBrand):
        * The car was released in \(releaseDate)
        * Horsepower = \(horsePower)\n
        """
        
        if let trailer = trailer {
            result += "* There is a \(trailer.rawValue) trailer\n"
        }
        if let maxCargoWeight = maxCargoWeight {
            result += "* Truck can transport \(maxCargoWeight) kg\n"
        }
        
        result += """
        \nDetailed information about \(carBrand):
        # Doors are \(doorsStatus.rawValue)
        # Windows are \(windowsStatus.rawValue)
        # Engine is \(engineStatus.rawValue)\n
        """
        
        return result
    }
    
    func hookUpTailer(trailer: KindOfTrailer, maxCargoWeight: Int) {
        guard self.trailer == nil else { return }
        self.trailer = trailer
        self.maxCargoWeight = maxCargoWeight
    }
    
    func unhookTrailer() {
        self.trailer = nil
        self.maxCargoWeight = nil
    }
    
    init(carBrand: String, releaseDate: Int, horsePower: Int, trailer: KindOfTrailer?, maxCargoWeight: Int?) {
        self.carBrand = carBrand
        self.releaseDate = releaseDate
        self.horsePower = horsePower
        
        self.doorsStatus = .close
        self.windowsStatus = .close
        self.engineStatus = .off
        
        self.trailer = trailer
        if trailer != nil {
            self.maxCargoWeight = maxCargoWeight
        }
    }
        
    convenience init(carBrand: String, releaseDate: Int, horsePower: Int) {
        self.init(carBrand: carBrand, releaseDate: releaseDate, horsePower: horsePower, trailer: nil, maxCargoWeight: nil)
    }
}

// MARK: - Tests for classes

let sportCar = SportCar(carBrand: "Nissan", releaseDate: 2021, horsePower: 500, maxSpeed: 250, weight: 1500)
sportCar.changeStatusOfRoof(to: .open)
sportCar.changeStatusOfEngine(to: .on)
print(sportCar)

let trunkCar = TrunkCar(carBrand: "KAMAZ", releaseDate: 2021, horsePower: 750)
trunkCar.hookUpTailer(trailer: .container, maxCargoWeight: 20_000)
trunkCar.changeStatusOfWindows(to: .open)
print(trunkCar)
