import UIKit
import Alamofire

struct PuntajeTop: Codable {
    let user_id: String
    let score: Int
    let created_at: String?
}

class tableViewController: UIViewController {
    
    @IBOutlet weak var jugadoresTableView: UITableView!
    
    var nombresConPuntajes: [PuntajeTop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jugadoresTableView.dataSource = self
        jugadoresTableView.delegate = self
        
        obtenerTop10Global()
    }
    
    func obtenerTop10Global() {
        let url = "https://lvmybcyhrbisfjouhbrx.supabase.co/rest/v1/scores?order=score.desc&limit=10"
        let token = UserDefaults.standard.string(forKey: "access_token") ?? ""
        let headers: HTTPHeaders = [
            "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE",
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]

        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: [PuntajeTop].self) { response in
                switch response.result {
                case .success(let datos):
                    DispatchQueue.main.async {
                        self.nombresConPuntajes = datos
                        self.jugadoresTableView.reloadData()
                    }
                case .failure(let error):
                    print("❌ Error al obtener Top 10: \(error)")
                }
            }
    }
}

extension tableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombresConPuntajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "NombrePuntajeCell", for: indexPath)
        let puntaje = nombresConPuntajes[indexPath.row]
        
        // Parsear fecha si querés mostrarla (opcional)
        var fechaTexto = ""
        if let rawDate = puntaje.created_at {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MM-dd-yyyy"
            
            if let date = inputFormatter.date(from: rawDate) {
                fechaTexto = displayFormatter.string(from: date)
            }
        }
        
        celda.textLabel?.text = "\(indexPath.row + 1). ID: \(puntaje.user_id.prefix(3)) – \(puntaje.score) pts – \(fechaTexto)"
        return celda
    }
}
