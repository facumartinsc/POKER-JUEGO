
import UIKit

class homeViewController: UIViewController{
    let dataController  = SaveReadController()
    
    @IBOutlet weak var juegosTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var jugador2Label: UILabel!
    //@IBOutlet weak var jugador1TextField: UITextField!
    //@IBOutlet weak var jugador2TextField: UITextField!
    @IBOutlet weak var jugarButton: UIButton!
    @IBOutlet weak var top10Button: UIButton!
    
    @IBOutlet weak var misPuntajesButton: UIButton!
    
    let juegos = ["Póker", "Tócame"]
    
    let pickerView = UIPickerView()
    
    var nombreUsuario: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        juegosTextField.inputView = pickerView
        
        misPuntajesButton.isEnabled = false
        
        //jugador1TextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        //jugador2TextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
        jugarButton.isEnabled = false
        top10Button.isEnabled = false
        
        
        if let nombre = nombreUsuario, !nombre.isEmpty {
            titleLabel.text = "¡Hola, \(nombre)!"
        } else {
            titleLabel.text = "¡Bienvenido!"
        }
        
    }
    
    func guardarPuntaje(_ puntaje: Int) {
        
        print("🚀 Guardar puntaje: \(puntaje), usuario: \(nombreUsuario ?? "nil")") // <- 🚀 ESTE PRINT

        if let username = nombreUsuario {
            dataController.addScore(username: username, score: puntaje)
        }
    }
    
    @IBAction func jugarButtonTocado(_ sender: Any) {
     
     let juegoElegido = juegosTextField.text
     
     /*if jugador1TextField.text == "" && jugador2TextField.text == ""{
     jugarButton.isEnabled = true
     } else {
     jugarButton.isEnabled = false
     }*/
     
     if juegoElegido == "Póker" {
     performSegue(withIdentifier: "goToPokerVC", sender: self)

     } else if juegoElegido == "Tócame" {
     performSegue(withIdentifier: "goToTocadoVC", sender: self)

     }
    }
    
    @IBAction func misPuntajesButtonTocado(_ sender: Any) {
        performSegue(withIdentifier: "goToMisPuntajesVC", sender: self)
            
    }
    @IBAction func ayudaButtonTocado(_ sender: Any) {
        mostrarAyuda()
    }
    
    @IBAction func top10ButtonTocado(_ sender: Any) {
        print("Botón Top 10 tocado")
        performSegue(withIdentifier: "goToTablaVC", sender: self)
    }
}
    

    
    /*@objc func textFieldsChanged() {
     let jugador1NoVacio = !(jugador1TextField.text?.isEmpty ?? true)
     let jugador2NoVacio = !(jugador2TextField.text?.isEmpty ?? true)
     
     let juegoElegido = juegosTextField.text ?? ""
     
     if juegoElegido == "Póker" {
     jugarButton.isEnabled = jugador1NoVacio && jugador2NoVacio
     
     } else if juegoElegido == "Tócame" {
     jugarButton.isEnabled = jugador1NoVacio
     
     } else {
     jugarButton.isEnabled = false
     }
     }*/
    
    
extension homeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return juegos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return juegos[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        juegosTextField.text = juegos[row]
        self.view.endEditing(true)
        
        let seleccion = juegos[row]
        
        if seleccion == "Tócame" {
            //jugador1TextField.isHidden = false
            //jugador2TextField.isHidden = true
            //jugador2Label.isHidden = true
            misPuntajesButton.isEnabled = true
            jugarButton.isEnabled = true
            top10Button.isEnabled = true
        } else {
            //jugador2TextField.isHidden = false
            titleLabel.isHidden = false
            //jugador2Label.isHidden = false
            misPuntajesButton.isEnabled = false
            jugarButton.isEnabled = true
            top10Button.isEnabled = false
        }
    }
    
    func mostrarAyuda() {
        let juegoElegido = juegosTextField.text ?? ""
        var mensajeAyuda = ""
        
        if juegoElegido == "Tócame" {
            mensajeAyuda = """
                Bienvenido a Tócame. Este es un juego rápido y sencillo que pone a prueba tu velocidad de reacción.
                
                Reglas básicas:
                1. Selecciona el juego “Tócame” en el menú de inicio.
                2. Espera a que el botón aparezca en la pantalla.
                3. Toca el botón lo más rápido que puedas.
                4. Tu tiempo de reacción se convierte en tu puntaje.
                5. Guarda tus puntajes y compite contigo mismo para mejorar cada vez más.
                """
        } else if juegoElegido == "Póker" {
            mensajeAyuda = """
                Póker es un juego clásico de cartas donde el objetivo es formar la mejor mano posible para ganar la partida.
                
                Reglas básicas:
                1. Cada jugador recibe 5 cartas al comienzo de la partida.
                2. Cada jugador puede cambiar hasta 3 cartas para mejorar su mano.
                3. Las combinaciones de cartas, de mayor a menor valor, son las siguientes:
                   - Escalera Real (A, K, Q, J, 10 del mismo palo)
                   - Escalera de Color (cinco cartas consecutivas del mismo palo)
                   - Póker (cuatro cartas del mismo número)
                   - Full (un trío y una pareja)
                   - Color (cinco cartas del mismo palo)
                   - Escalera (cinco cartas consecutivas de cualquier palo)
                   - Trío (tres cartas del mismo número)
                   - Doble Pareja (dos pares)
                   - Pareja (dos cartas del mismo número)
                   - Carta Alta (cuando no se forma ninguna combinación)
                4. Gana el jugador que tenga la mejor mano al final de la partida.
                """
        } else {
            mensajeAyuda = "Por favor, selecciona un juego para ver las reglas."
        }
        
        let alerta = UIAlertController(title: "Ayuda para \(juegoElegido)", message: mensajeAyuda, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPokerVC" {
            if let destino = segue.destination as? pokerViewController {
                destino.jugador1 = nombreUsuario
                //destino.jugador2 = nombreUsuario.text
            }
        } else if segue.identifier == "goToTocadoVC" {
            if let destino = segue.destination as? tocameViewController {
                destino.nombreJugador = nombreUsuario
            }
        } else if segue.identifier == "goToMisPuntajesVC" {
            if let destino = segue.destination as? MisPuntajesViewController {
                destino.username = nombreUsuario // El nombre de usuario actual
            }
            
        }
    }
    
}
