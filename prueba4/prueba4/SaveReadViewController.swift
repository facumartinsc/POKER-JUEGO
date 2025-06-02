import Foundation

struct User: Codable {
    var nombre: String
    var username: String
    var password: String
    var puntajes: [Int]
}

class SaveReadController {
    
    private var dataBase: [String: User] = [:]
    
    init() {
        loadDatabase()
    }
    
    func registerNewUser(nombre: String, username: String, password: String) -> String {
        if dataBase[username] != nil {
            return "Ya existe el nombre de usuario"
        }
        
        let newUser = User(nombre: nombre, username: username, password: password, puntajes: [])
        dataBase[username] = newUser
        saveDatabase()
        return "¡Se ha registrado correctamente!"
    }
    
    func checkLogin(username: String, password: String) -> (Int, String) {
        if let user = dataBase[username] {
            if user.password == password {
                return (0, user.username)
            } else {
                return (1, "Contraseña incorrecta")
            }
        }
        return (2, "Usuario no encontrado")
    }
    
    func addScore(username: String, score: Int) {
        guard var user = dataBase[username] else { return }
        user.puntajes.append(score)
        dataBase[username] = user
        saveDatabase()
    }
    
    func getAllScores() -> [(String, Int)] {
        var allScores: [(String, Int)] = []
        for (username, user) in dataBase {
            for score in user.puntajes {
                allScores.append((username, score))
            }
        }
        return allScores.sorted(by: { $0.1 > $1.1 })
    }
    
    func getScores(for username: String) -> [Int] {
        return dataBase[username]?.puntajes.sorted(by: >) ?? []
    }
    
    private func saveDatabase() {
        if let data = try? JSONEncoder().encode(dataBase) {
            UserDefaults.standard.set(data, forKey: "gameData")
        }
    }
    
     func loadDatabase() {
        if let data = UserDefaults.standard.data(forKey: "gameData"),
           let loaded = try? JSONDecoder().decode([String: User].self, from: data) {
            dataBase = loaded
        }
    }
    
}

