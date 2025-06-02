import UIKit

class MisPuntajesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dataController = SaveReadController()
    var username: String?
    var puntajes: [Int] = []
    
    @IBOutlet weak var misPuntajesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura la tableView
        misPuntajesTableView.dataSource = self
        misPuntajesTableView.delegate = self
        
        dataController.loadDatabase()
        
        // Carga los puntajes del usuario actual
        if let user = username {
            //dataController.addScore(username: user, score: Int.random(in: 1...100))
            puntajes = dataController.getScores(for: user)
            print("Puntajes de \(user): \(puntajes)")
            misPuntajesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return puntajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntajeCell", for: indexPath)
        let puntaje = puntajes[indexPath.row]
        if let usuario = username {
            cell.textLabel?.text = "\(usuario): \(puntaje)"
        } else {
            cell.textLabel?.text = "Puntaje: \(puntaje)"
        }
        return cell
    }
}
