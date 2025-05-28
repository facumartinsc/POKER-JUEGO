
import UIKit

class SecondViewController: UIViewController{
    @IBOutlet weak var juegosTextField: UITextField!
    @IBOutlet weak var jugador1Label: UILabel!
    @IBOutlet weak var jugador2Label: UILabel!
    @IBOutlet weak var jugador1TextField: UITextField!
    @IBOutlet weak var jugador2TextField: UITextField!
    @IBOutlet weak var jugarButton: UIButton!
    
    let juegos = ["Póker", "Tócame"]
    
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        juegosTextField.inputView = pickerView
        
        jugador1TextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        jugador2TextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
        jugarButton.isEnabled = false
        
    }
    
    @objc func textFieldsChanged() {
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
    }
    
    @IBAction func jugarButtonTocado(_ sender: Any) {
        
        let juegoElegido = juegosTextField.text
        
        if jugador1TextField.text == "" && jugador2TextField.text == ""{
            jugarButton.isEnabled = true
        } else {
            jugarButton.isEnabled = false
        }
        
        if juegoElegido == "Póker" {
            performSegue(withIdentifier: "goToPokerVC", sender: self)
            jugador1TextField.text = ""
            jugador2TextField.text = ""
        } else if juegoElegido == "Tócame" {
            performSegue(withIdentifier: "goToTocadoVC", sender: self)
            jugador1TextField.text = ""
        }
    }
}

extension SecondViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            jugador1TextField.isHidden = false
            jugador2TextField.isHidden = true
            jugador2Label.isHidden = true
        } else {
            jugador2TextField.isHidden = false
            jugador1Label.isHidden = false
            jugador2Label.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPokerVC" {
            if let destino = segue.destination as? ViewController {
                destino.jugador1 = jugador1TextField.text
                destino.jugador2 = jugador2TextField.text
            }
        } else if segue.identifier == "goToTocadoVC" {
            if let destino = segue.destination as? ThirdViewController {
                destino.nombreJugador = jugador1TextField.text
            }
        }
    }
}
