import UIKit
import Alamofire

class loginViewController: UIViewController {
    //let dataController = SaveReadController()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var username: String?   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        userTextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none


        
    }
    @IBAction func loginButtonTocado(_ sender: Any) {
            let email = userTextField.text ?? ""
            let password = passwordTextField.text ?? ""

            guard !email.isEmpty, !password.isEmpty else {
                showAlert("Completa todos los campos")
                return
            }

            let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"
            let url = "https://lvmybcyhrbisfjouhbrx.supabase.co/auth/v1/token?grant_type=password"

            let headers: HTTPHeaders = [
                "apikey": apiKey,
                "Content-Type": "application/json"
            ]

            let parametros: [String: String] = [
                "email": email,
                "password": password
            ]

            AF.request(url, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let json = value as? [String: Any],
                           let accessToken = json["access_token"] as? String,
                           let userData = json["user"] as? [String: Any],
                           let idUser = userData["id"] as? String {

                            print("🔐 Access token: \(accessToken)")
                            print("🆔 ID del usuario: \(idUser)")

                            UserDefaults.standard.set(accessToken, forKey: "access_token")
                            UserDefaults.standard.set(idUser, forKey: "id")

                            self.username = email // temporal
                            self.performSegue(withIdentifier: "goToHomeVC", sender: self)

                        } else {
                            self.showAlert("❌ Login falló: respuesta inesperada.")
                        }

                        

                    case .failure(let error):
                        self.showAlert("Error: \(error.localizedDescription)")
                        if let data = response.data,
                           let mensaje = String(data: data, encoding: .utf8) {
                            print("📩 Supabase dijo:\n\(mensaje)")
                        }
                    }
                }
        }
    
    func obtenerUsuario(token: String, apiKey: String) {
        let url = "https://lvmybcyhrbisfjouhbrx.supabase.co/auth/v1/user"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "apikey": apiKey
        ]

        AF.request(url, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let metadata = json["user_metadata"] as? [String: Any],
                       let username = metadata["username"] as? String {

                        print("✅ Username obtenido: \(username)")
                        self.username = username
                        self.performSegue(withIdentifier: "goToHomeVC", sender: self)

                    } else {
                        self.showAlert("No se encontró el username")
                    }

                case .failure(let error):
                    self.showAlert("Error al obtener el usuario: \(error.localizedDescription)")
                }
            }
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHomeVC" {
            if let homeVC = segue.destination as? homeViewController {
                homeVC.nombreUsuario = self.username
            }
        }
    }
    
    private func showAlert(_ mensaje: String) {
        let alerta = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
    
}
