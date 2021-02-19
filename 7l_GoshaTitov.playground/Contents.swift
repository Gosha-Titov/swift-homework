import UIKit

// MARK: - The first task -> (Answer?, Error?)

typealias Music = String

enum MusicError: Error {
    case thereIsNoPreviousSong
    case thereIsNoNextSong
    case thereAreNoSongsInPlaylist
    
    var localizedDescription: String {
        switch self {
        case .thereIsNoPreviousSong:
            return "There is no previous song!"
        case .thereIsNoNextSong:
            return "There is no next song!"
        case .thereAreNoSongsInPlaylist:
            return "There are no songs in your playlist!"
        }
    }
}

class Playlist {
    private var playlist: [Music?]
    private var indexOfCurrentSong: Int = 0
    
    func getPreviousSong() -> (song: Music?, error: MusicError?) {
        guard playlist.count > 0 else {
            return (nil, MusicError.thereAreNoSongsInPlaylist)
        }
        guard indexOfCurrentSong > 0 else {
            return (nil, MusicError.thereIsNoPreviousSong)
        }
        indexOfCurrentSong -= 1
        return (playlist[indexOfCurrentSong], nil)
    }
    
    func getCurrentSong() -> (song: Music?, error: MusicError?) {
        guard playlist.count > 0 else {
            return (nil, MusicError.thereAreNoSongsInPlaylist)
        }
        return (playlist[indexOfCurrentSong], nil)
    }
    
    func getNextSong() -> (song: Music?, error: MusicError?) {
        guard playlist.count > 0 else {
            return (nil, MusicError.thereAreNoSongsInPlaylist)
        }
        guard indexOfCurrentSong < playlist.count - 1 else {
            return (nil, MusicError.thereIsNoNextSong)
        }
        indexOfCurrentSong += 1
        return (playlist[indexOfCurrentSong], nil)
    }

    func addSong(_ song: Music) {
        playlist.append(song)
    }
    
    init(_ playlist: Music?...) {
        self.playlist = playlist
    }
}

let playlist = Playlist("Arctic Monkeys – 505", "The Neighbourhood – Sweater Weather")

let action1 = playlist.getCurrentSong()
if let song = action1.song {
    print("Now playing: \(song)")
} else if let error = action1.error {
    print(error.localizedDescription)
}

let action2 = playlist.getNextSong()
if let song = action2.song {
    print("Now playing: \(song)")
} else if let error = action2.error {
    print(error.localizedDescription)
}

let action3 = playlist.getNextSong()
if let song = action3.song {
    print("Now playing: \(song)")
} else if let error = action3.error {
    print(error.localizedDescription)
}
print("\n")



// MARK: - The second task: Implementation of simple messenger with Errors -> throw Error

typealias UserName = String

enum UserError: Error {
    case userNameIsNotSet
    case messageIsEmpty
    case userIsNotFound
    case userNameIsImpossible
    case userNameIsNotAvailable
    case userWithThisUserNameExists
    case userWithThisUserNameDoesNotExist
}

enum UserStatus {
    case sender
    case receiver
}


class User {
    private static var dataBase = [UserName: User]()
    
    private var userName: String?
    
    var messages = [UserName: [(UserStatus, message: String)] ]()
    
    func sendMessage(to otherUserName: UserName, message: String) throws {
        guard userName != nil else {
            throw UserError.userNameIsNotSet
        }
        guard message != "" else {
            throw UserError.messageIsEmpty
        }
        guard let otherUser = User.dataBase[otherUserName] else {
            throw UserError.userIsNotFound
        }
        
        if messages[otherUserName] == nil {
            messages[otherUserName] = []
        }
        
        messages[otherUserName]?.append( (.sender, message) )
        
        otherUser.receiveMessage(from: userName!, message: message)
    }

    
    func setUserName(_ newUserName: UserName) throws {
        guard newUserName != "" else {
            throw UserError.userNameIsImpossible
        }
        guard User.dataBase[newUserName] == nil else {
            throw UserError.userNameIsNotAvailable
        }
        
        if let userName = userName {
            try! User.removeUserFromDataBase(userName: userName)
        }
        
        try! User.addUserInDataBase(userName: newUserName, user: self)
        self.userName = newUserName
    }
    
    
    func receiveMessage(from otherUserName: UserName, message: String) {
        if messages[otherUserName] == nil {
            messages[otherUserName] = []
        }
        messages[otherUserName]!.append( (.receiver, message) )
    }
    
    private static func addUserInDataBase(userName: UserName, user: User) throws {
        guard User.dataBase[userName] == nil else {
            throw UserError.userWithThisUserNameExists
        }
        User.dataBase[userName] = user
    }
    
    private static func removeUserFromDataBase(userName: UserName) throws {
        guard User.dataBase[userName] != nil else {
            throw UserError.userWithThisUserNameDoesNotExist
        }
        
        User.dataBase[userName] = nil
    }
}

extension User {
    func showMessages(with otherUserName: UserName) throws {
        guard userName != nil else {
            throw UserError.userNameIsNotSet
        }
        guard User.dataBase[otherUserName] != nil else {
            throw UserError.userWithThisUserNameDoesNotExist
        }
        print("––––< Dialogue between \(userName!) and \(otherUserName) >––––\n")
        if messages[otherUserName] == nil {
            print("There is no dialogue, but you can start it!\n\n")
        } else {
            for (who, message) in messages[otherUserName]! {
                print("\(who == .sender ? "You" : otherUserName): \(message)")
            }
            print("\n\n")
        }
    }
    
    func deleteMessages(with otherUserName: UserName) throws {
        guard User.dataBase[otherUserName] != nil else {
            throw UserError.userWithThisUserNameDoesNotExist
        }
        
        messages[otherUserName] = nil
    }
}

// MARK: - Test

let gosha = User()
let misha = User()
do {
    try gosha.setUserName("Gosha")
    try misha.setUserName("Misha")
} catch UserError.userNameIsImpossible {
    print("This user name is impossible!")
} catch UserError.userNameIsNotAvailable {
    print("This user name is not available!")
}

do {
    try gosha.sendMessage(to: "Misha", message: "Hello! I'm glad to see you here!")
    try gosha.sendMessage(to: "Misha", message: "What's new with you?")
    
    try misha.sendMessage(to: "Gosha", message: "Greetings! I'm happy! Thanks! What about you?")
    try gosha.sendMessage(to: "Misha", message: "I'm pretty good! Thank you!")
    
} catch UserError.userNameIsNotSet {
    print("You don't have a set user name!")
} catch UserError.messageIsEmpty {
    print("You try to send an empty message!")
} catch UserError.userIsNotFound {
    print("This user is not found!")
}

do {
    try gosha.deleteMessages(with: "Misha")
    try gosha.showMessages(with: "Misha")
    
    try misha.showMessages(with: "Gosha")
} catch UserError.userNameIsNotSet {
    print("You don't have a set user name!")
} catch UserError.userWithThisUserNameDoesNotExist {
    print("The user with this user name does not exist!")
}
