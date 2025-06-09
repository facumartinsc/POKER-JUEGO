import UIKit

class tocameViewController: UIViewController {
    @IBOutlet weak var zonaDeJuegoView: UIView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var tiempoLabel: UILabel!
    @IBOutlet weak var puntajeLabel: UILabel!
    @IBOutlet weak var jugarButton: UIButton!
    // @IBOutlet weak var tablaButton: UIButton!
    
    var pelotaView: UIView!
    
    var nombreJugador: String?
    
    var tiempoRestante = 30
    var timer: Timer?
    
    var puntaje = 0
    
    var juegoActivo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nombreLabel.text = SessionManager.shared.nombreUser

        
    }
    
    func crearPelota() {
        let anchoPelota: CGFloat = 50
        let altoPelota: CGFloat = 50
        
        let maxX = zonaDeJuegoView.bounds.width - anchoPelota
        let maxY = zonaDeJuegoView.bounds.height - altoPelota
        
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        
        pelotaView = UIView(frame: CGRect(x: randomX, y: randomY, width: anchoPelota, height: altoPelota))
        pelotaView.backgroundColor = .yellow
        pelotaView.layer.cornerRadius = anchoPelota / 2
        zonaDeJuegoView.addSubview(pelotaView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pelotaTocada))
        pelotaView.addGestureRecognizer(tapGesture)
        pelotaView.isUserInteractionEnabled = true
    }
    
    
    func iniciarTemporizador() {
        tiempoRestante = 30
        tiempoLabel.text = "\(tiempoRestante)"
        
        puntaje = 0
        puntajeLabel.text = "Puntaje: \(puntaje)"
        
        juegoActivo = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(actualizarTiempo), userInfo: nil, repeats: true)
        
        jugarButton.isEnabled = false
    }
    
    @objc func actualizarTiempo() {
        tiempoRestante -= 1
        tiempoLabel.text = "\(tiempoRestante)"
        
        if tiempoRestante <= 0 {
            print("🚀 Se terminó el tiempo, vamos a guardar el puntaje") // 🚀 Nuevo print para ver si entra

            timer?.invalidate()
            
            //if let homeVC = presentingViewController as? homeViewController {
            if let homeVC = navigationController?.viewControllers.first(where: { $0 is homeViewController }) as? homeViewController {
                let fecha = Date()
                let formatter = DateFormatter()
                  formatter.dateFormat = "MM-dd-yyyy"
                let date = formatter.string(from: fecha)
                print("La fecha que deberia de salir: "/*, date*/)
                print("🚀 Llamando a guardarPuntaje desde Tócame") // 🚀 Otro print
                if let token = UserDefaults.standard.string(forKey: "access_token"), let id = UserDefaults.standard.string(forKey: "id") {
                    
                    homeVC.guardarPuntaje(puntaje, token: token, id: id, date: date)
                }
            }
            
            /*var datosGuardados = UserDefaults.standard.array(forKey: "nombresConPuntajes") as? [[String: Any]] ?? []
            let nuevoDato: [String: Any] = ["nombre": nombreJugador ?? "Sin nombre", "puntaje": puntaje]
            datosGuardados.append(nuevoDato)
            UserDefaults.standard.set(datosGuardados, forKey: "nombresConPuntajes")*/
            
            let alerta = UIAlertController(title: "¡Fin del juego!", message: "El tiempo ha terminado.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alerta, animated: true, completion: nil)
            
            pelotaView.removeFromSuperview()
            
            juegoActivo = false
            jugarButton.isEnabled = true
        }
    }
    
    
    @objc func pelotaTocada() {
        
        guard juegoActivo else {return}
        
        puntaje += 1
        puntajeLabel.text = "Puntaje: \(puntaje)"
        
        moverPelotita()
    }
    
    func moverPelotita() {
        let maxX = zonaDeJuegoView.bounds.width - pelotaView.frame.width
        let maxY = zonaDeJuegoView.bounds.height - pelotaView.frame.height
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        
        UIView.animate(withDuration: 0.3) {
            self.pelotaView.frame.origin = CGPoint(x: randomX, y: randomY)
        }
    }
    
    @IBAction func jugarButtonTocado(_ sender: Any) {
        iniciarTemporizador()
        crearPelota()
    }
    
    /* @IBAction func tocarTablaButton(_ sender: Any) {
     performSegue(withIdentifier: "goToTablaVC", sender: self)
     }
     }*/
    
}

