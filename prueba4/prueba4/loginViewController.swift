import UIKit

class loginViewController: UIViewController {
    //let dataController = SaveReadController()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true

        
    }
    @IBAction func loginButtonTocado(_ sender: Any) {
        
        let dataController = SaveReadController()
        let usuario = userTextField.text ?? ""
        let contrasena = passwordTextField.text ?? ""
        
        let (codigo, mensaje) = dataController.checkLogin(username: usuario, password: contrasena)
        
        if codigo == 0 {
            performSegue(withIdentifier: "goToHomeVC", sender: self)
        } else {
            let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHomeVC" {
            if let destino = segue.destination as? homeViewController {
                destino.nombreUsuario = userTextField.text
            }
        }
    }
}
