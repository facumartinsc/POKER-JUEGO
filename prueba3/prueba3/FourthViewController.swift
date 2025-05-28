import UIKit

class FourthViewController: UIViewController {
    @IBOutlet weak var jugadoresTableView: UITableView!
    
    
    
    var nombresConPuntajes: [(String, Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let datosGuardados = UserDefaults.standard.array(forKey: "nombresConPuntajes") as? [[String: Any]] {
            nombresConPuntajes = datosGuardados.compactMap { dict in
                if let nombre = dict["nombre"] as? String,
                   let puntaje = dict["puntaje"] as? Int {
                    return (nombre, puntaje)
                }
                return nil
            }
            nombresConPuntajes.sort { $0.1 > $1.1 }
        }
        jugadoresTableView.dataSource = self
    }
}

extension FourthViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "NombrePuntajeCell", for: indexPath)
        let (nombre, puntaje) = nombresConPuntajes[indexPath.row]
        celda.textLabel?.text = "\(nombre): \(puntaje)"
        return celda
    }
}
