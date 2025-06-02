import UIKit

class registerViewController: UIViewController {
    
    let dataController = SaveReadController()
    
    // Campos de texto
    let nombreField = UITextField()
    let usuarioField = UITextField()
    let contrasenaField = UITextField()
    let confirmarContrasena = UITextField()
    let tituloLabel = UILabel()
    
    var usuarios: [String: String] = [:]
    
    // Botón de registro
    let registerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configurarCampos()
        configurarVista()
        configurarTitulo()
        registrarUsuario()
        
        registerButton.addTarget(self, action: #selector(registrarUsuario), for: .touchUpInside)
    }
    
    private func configurarTitulo() {
        tituloLabel.text = "Registro"
        tituloLabel.font = UIFont.boldSystemFont(ofSize: 24)
        tituloLabel.textAlignment = .center
    }
    
    private func configurarCampos() {
        // Personaliza los campos
        [nombreField, usuarioField, contrasenaField, confirmarContrasena].forEach {
            $0.borderStyle = .roundedRect
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        nombreField.placeholder = "Nombre:"
        usuarioField.placeholder = "Usuario:"
        contrasenaField.placeholder = "Contraseña:"
        confirmarContrasena.placeholder = "Confirmar contraseña: "
        contrasenaField.isSecureTextEntry = true
        
        
        // Botón
        registerButton.setTitle("Completado", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 8
        registerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    private func configurarVista() {
        // Stack de nombre y usuario (horizontal)
        let nombreUsuarioStack = UIStackView(arrangedSubviews: [nombreField, usuarioField])
        nombreUsuarioStack.axis = .vertical
        nombreUsuarioStack.spacing = 10
        nombreUsuarioStack.distribution = .fillEqually
        
        // Stack de contraseña y correo (horizontal)
        let contraStack = UIStackView(arrangedSubviews: [contrasenaField, confirmarContrasena])
        contraStack.axis = .vertical
        contraStack.spacing = 10
        contraStack.distribution = .fillEqually
        
        // Stack principal (vertical)
        let mainStack = UIStackView(arrangedSubviews: [
            tituloLabel,
            nombreUsuarioStack,
            contraStack,
            registerButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        
        // Añade a la vista
        view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 35)
        ])
    }
    
    private func showAlert(_ mensaje: String) {
        let alerta = UIAlertController(title: "Registro", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if mensaje == "¡Se ha registrado correctamente!" {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        present(alerta, animated: true)
    }
    
    @objc private func registrarUsuario() {
        let nombre = nombreField.text ?? ""
        let usuario = usuarioField.text ?? ""
        let contrasenha = contrasenaField.text ?? ""
        let confirmarContrasenha = confirmarContrasena.text ?? ""
        
        guard !nombre.isEmpty,!usuario.isEmpty && !contrasenha.isEmpty && !confirmarContrasenha.isEmpty else {
            showAlert("Completa todos los campos")
            return
        }
        // compara contraseñas
        guard contrasenha == confirmarContrasenha else {
            showAlert("Las contraseñas no coinciden")
            return
        }
        
        let resultado = dataController.registerNewUser(nombre: nombre, username: usuario, password: contrasenha)
        showAlert(resultado)
        print(resultado)
        return
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
    }


