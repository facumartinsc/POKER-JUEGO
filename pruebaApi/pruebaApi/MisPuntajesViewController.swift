import UIKit
import Alamofire

struct Puntaje: Codable {
    let score: Int
    let created_at: String?
}

class MisPuntajesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dataController = SaveReadController()
    var username: String?
    var puntajes: [Puntaje] = []
    
    @IBOutlet weak var misPuntajesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura la tableView
        misPuntajesTableView.dataSource = self
        misPuntajesTableView.delegate = self
        
        dataController.loadDatabase()
        
        if let user = username {
            if let token = UserDefaults.standard.string(forKey: "access_token"), let idUser = UserDefaults.standard.string(forKey: "id") {
                obtenerPuntajesDelServidor(usuario: idUser, token: token)
            } else {
                print("No me llega el token")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return puntajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "puntajeCell", for: indexPath)
        let puntaje = puntajes[indexPath.row]
        
        let usuario = SessionManager.shared.nombreUser
        var fechaTexto = ""
        
        if let rawDate = puntaje.created_at {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM-dd-yyyy"
            outputFormatter.locale = Locale(identifier: "es_AR")
            
            if let date = inputFormatter.date(from: rawDate) {
                fechaTexto = outputFormatter.string(from: date)
            } else {
                print("❌ No se pudo parsear: \(rawDate)")
            }
        }
        
        cell.textLabel?.text = "\(usuario): \(puntaje.score) puntos – \(fechaTexto)"
        return cell
    }
    
    func obtenerPuntajesDelServidor(usuario: String, token: String) {
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"
        let url = "https://lvmybcyhrbisfjouhbrx.supabase.co/rest/v1/scores?user_id=eq.\(usuario)"

        let headers: HTTPHeaders = [
            "apikey": apiKey,
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        print("Esto es lo que buscamos", usuario)

        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: [Puntaje].self) { response in
                switch response.result {
                case .success(let scores):
                    DispatchQueue.main.async {
                        self.puntajes = scores.sorted(by: { $0.score > $1.score })
                        print("✅ Puntajes descargados: \(scores.count)")
                        for puntaje in scores {
                            print("🎯 Score: \(puntaje.score), Fecha: \(puntaje.created_at ?? "sin fecha")")
                        }
                        self.misPuntajesTableView.reloadData()
                    }
                case .failure(let error):
                    print("❌ Error al obtener puntajes: \(error)")
                }
            }
    }
}
