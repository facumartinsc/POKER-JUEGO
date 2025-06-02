import UIKit

class tableViewController: UIViewController {
    @IBOutlet weak var jugadoresTableView: UITableView!
    
    let dataController = SaveReadController()
    var nombresConPuntajes: [(String, Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allScores = dataController.getAllScores()
        
        print("Usuarios con puntajes: \(allScores.map { $0.0 })") // 🚀
        nombresConPuntajes = Array(allScores.prefix(10))
        print("Top 10: \(nombresConPuntajes)") // 🚀
        
        jugadoresTableView.dataSource = self
        jugadoresTableView.reloadData()
    }
}

extension tableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombresConPuntajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "NombrePuntajeCell", for: indexPath)
        let (nombre, puntaje) = nombresConPuntajes[indexPath.row]
        celda.textLabel?.text = "\(indexPath.row + 1). \(nombre): \(puntaje)"
        return celda
    }
}

