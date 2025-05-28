import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var zonaDeJuegoView: UIView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var tiempoLabel: UILabel!
    @IBOutlet weak var puntajeLabel: UILabel!
    @IBOutlet weak var jugarButton: UIButton!
    @IBOutlet weak var tablaButton: UIButton!
    
    var pelotaView: UIView!
    
    var nombreJugador: String?
    
    var tiempoRestante = 30
    var timer: Timer?
    
    var puntaje = 0
    
    var juegoActivo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreLabel.text = nombreJugador
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
            timer?.invalidate()
            
            var datosGuardados = UserDefaults.standard.array(forKey: "nombresConPuntajes") as? [[String: Any]] ?? []
            let nuevoDato: [String: Any] = ["nombre": nombreJugador ?? "Sin nombre", "puntaje": puntaje]
            datosGuardados.append(nuevoDato)
            UserDefaults.standard.set(datosGuardados, forKey: "nombresConPuntajes")
            
            let alerta = UIAlertController(title: "¡Fin del juego!", message: "El tiempo ha terminado.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alerta, animated: true, completion: nil)
            
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
    
    @IBAction func tocarTablaButton(_ sender: Any) {
        performSegue(withIdentifier: "goToTablaVC", sender: self)
    }
}



