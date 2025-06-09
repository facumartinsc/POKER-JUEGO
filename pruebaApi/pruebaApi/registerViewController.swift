import UIKit
import Alamofire

class registerViewController: UIViewController {
    
    let usernameField = UITextField()
    let emailField = UITextField()
    let contrasenaField = UITextField()
    let confirmarContrasena = UITextField()
    let tituloLabel = UILabel()
    let registerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configurarCampos()
        configurarVista()
        configurarTitulo()
        
        registerButton.addTarget(self, action: #selector(registrarUsuario), for: .touchUpInside)
    }
    
    private func configurarTitulo() {
        tituloLabel.text = "Registro"
        tituloLabel.font = UIFont.boldSystemFont(ofSize: 24)
        tituloLabel.textAlignment = .center
    }
    
    private func configurarCampos() {
        [usernameField, emailField, contrasenaField, confirmarContrasena].forEach {
            $0.borderStyle = .roundedRect
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        usernameField.placeholder = "Usuario:"
        emailField.placeholder = "Email:"
        contrasenaField.placeholder = "Contraseña:"
        confirmarContrasena.placeholder = "Confirmar contraseña:"
        contrasenaField.isSecureTextEntry = true
        confirmarContrasena.isSecureTextEntry = true
        usernameField.autocapitalizationType = .none
        emailField.autocapitalizationType = .none
        contrasenaField.autocapitalizationType = .none
        confirmarContrasena.autocapitalizationType = .none

        
        registerButton.setTitle("Registrarse", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 8
        registerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func configurarVista() {
        let camposStack = UIStackView(arrangedSubviews: [usernameField, emailField, contrasenaField, confirmarContrasena])
        camposStack.axis = .vertical
        camposStack.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [
            tituloLabel,
            camposStack,
            registerButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.alignment = .fill
        
        view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 35)
        ])
    }
    
    @objc private func registrarUsuario() {
        let username = usernameField.text ?? ""
        let email = emailField.text ?? ""
        let contrasena = contrasenaField.text ?? ""
        let confirmar = confirmarContrasena.text ?? ""
        
        guard !username.isEmpty, !email.isEmpty, !contrasena.isEmpty, !confirmar.isEmpty else {
            showAlert("Completa todos los campos")
            return
        }
        
        guard contrasena == confirmar else {
            showAlert("Las contraseñas no coinciden")
            return
        }
        
        registrarUsuarioSupabase(email: email, password: contrasena, username: username)
    }
    
    private func registrarUsuarioSupabase(email: String, password: String, username: String) {
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"
        let url = "https://lvmybcyhrbisfjouhbrx.supabase.co/auth/v1/signup"

        let headers: HTTPHeaders = [
            "apikey": apiKey,
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        // 👇 Incluye el username dentro del campo `data` para guardarlo en metadata
        let params: [String: Any] = [
            "email": email,
            "password": password,
            "data": [
                "username": username
            ]
        ]
    
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any], json["error"] == nil {
                        SessionManager.shared.nombreUser = username
                        self.showAlert("¡Se ha registrado correctamente!")
                    } else {
                        self.showAlert("Error en el registro: \(value)")
                    }
                case .failure(let error):
                    self.showAlert("Error: \(error.localizedDescription)")
                }
            }
    }
    
    private func showAlert(_ mensaje: String) {
        let alerta = UIAlertController(title: "Registro", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
}


        
        /* 🚀 Guardar en el diccionario
         usuarios[usuario] = contrasenha
         print("Diccionario actual: \(usuarios)")
         
         let alerta = UIAlertController(title: "Registro", message: "¡Usuario registrado!", preferredStyle: .alert)
         alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
         self.dismiss(animated: true, completion: nil)
         }))
         present(alerta, animated: true)
         }*/



