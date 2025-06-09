import UIKit
import Alamofire

class homeViewController: UIViewController, UIScrollViewDelegate {
    
    let dataController = SaveReadController()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var jugarButton: UIButton!
    @IBOutlet weak var top10Button: UIButton!
    @IBOutlet weak var scrollViewSlider: UIScrollView!
    @IBOutlet weak var pageControlView: UIPageControl!
    @IBOutlet weak var misPuntajesButton: UIButton!

    let juegos = ["Póker", "Tócame", "Otro"]
    
    var nombreUsuario: String?
    var juegoElegido: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SessionManager.shared.cargarNombreDesdeSupabase {
            DispatchQueue.main.async {
                self.titleLabel.text = "¡Hola, \(SessionManager.shared.nombreUser)!"
            }
        }
        
        slider()
        
        scrollViewSlider.delegate = self
        scrollViewSlider.isPagingEnabled = true
        scrollViewSlider.isScrollEnabled = true

        jugarButton.isEnabled = true
        top10Button.isEnabled = false
        misPuntajesButton.isEnabled = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slider()
      }
    
    func slider() {
        let images = ["Poker", "Tocame"]
        print("ScrollView width:", scrollViewSlider.frame.width)

        scrollViewSlider.subviews.forEach { $0.removeFromSuperview() }

        let scrollWidth = scrollViewSlider.frame.width
        let scrollHeight = scrollViewSlider.frame.height
        let padding: CGFloat = 16
        let containerWidth = scrollWidth - padding * 2

        for (index, imageName) in images.enumerated() {
            // Contenedor con sombra y esquinas redondeadas
            let container = UIView(frame: CGRect(x: CGFloat(index) * scrollWidth + padding,
                                                 y: 10,
                                                 width: containerWidth,
                                                 height: scrollHeight - 20))
            container.backgroundColor = .white
            container.layer.cornerRadius = 20
            container.layer.shadowColor = UIColor.black.cgColor
            container.layer.shadowOpacity = 0.2
            container.layer.shadowOffset = CGSize(width: 0, height: 2)
            container.layer.shadowRadius = 6
            container.layer.masksToBounds = false

            // Imagen dentro del contenedor
            let imageView = UIImageView(frame: container.bounds)
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20

            container.addSubview(imageView)
            scrollViewSlider.addSubview(container)
        }

        scrollViewSlider.contentSize = CGSize(width: scrollWidth * CGFloat(images.count), height: scrollHeight)
        scrollViewSlider.showsHorizontalScrollIndicator = false
        scrollViewSlider.decelerationRate = .fast
        scrollViewSlider.isPagingEnabled = true

        pageControlView.numberOfPages = images.count
    }

    
   /* func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        
        if pageIndex >= 0 && pageIndex < juegos.count {
            pageControlView.currentPage = pageIndex
            juegoElegido = juegos[pageIndex]
            print("Juego elegido: \(juegoElegido!)")
            actualizarBotonesParaJuego()
        } else {
            print("⚠️ Índice fuera de rango: \(pageIndex)")
        }
    }*/
    
    func actualizarBotonesParaJuego() {
        guard let juego = juegoElegido else {
            jugarButton.isEnabled = false
            top10Button.isEnabled = false
            misPuntajesButton.isEnabled = false
            return
        }

        switch juego {
        case "Póker":
            jugarButton.isEnabled = true
            top10Button.isEnabled = false
            misPuntajesButton.isEnabled = false
        case "Tócame":
            jugarButton.isEnabled = true
            top10Button.isEnabled = true
            misPuntajesButton.isEnabled = true
        default:
            jugarButton.isEnabled = false
            top10Button.isEnabled = false
            misPuntajesButton.isEnabled = false
        }
    }
    
    
    
    func cambiarPagina(direccion: Int) {
        var newPage = pageControlView.currentPage + direccion
        newPage = max(0, min(newPage, pageControlView.numberOfPages - 1))
        pageControlView.currentPage = newPage

        let offset = CGFloat(newPage) * scrollViewSlider.frame.size.width
        scrollViewSlider.setContentOffset(CGPoint(x: offset, y: 0), animated: true)

        juegoElegido = juegos[newPage]
        actualizarBotonesParaJuego()
    }
    
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let offset = CGFloat(sender.currentPage) * scrollViewSlider.frame.size.width
        scrollViewSlider.setContentOffset(CGPoint(x: offset, y: 0), animated: true)

        juegoElegido = juegos[sender.currentPage]
        actualizarBotonesParaJuego()
    }

    

    @IBAction func leftArrowTapped(_ sender: Any) {
        cambiarPagina(direccion: -1)
    }
    
    @IBAction func rightArrowTapped(_ sender: Any) {
        cambiarPagina(direccion: 1)
    }
    
    
    @IBAction func jugarButtonTocado(_ sender: Any) {
        guard let juegoElegido = juegoElegido else { return }
        
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
        performSegue(withIdentifier: "goToTablaVC", sender: self)
    }
    
    func 	guardarPuntaje(_ puntaje: Int, token: String, id: String, date:String) {
        let url = "https://lvmybcyhrbisfjouhbrx.supabase.co/rest/v1/scores"
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"

        let headers: HTTPHeaders = [
            "apikey": apiKey,
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]

        let parametros: [String: Any] = [
            "user_id": id,
            "game_id": "1",
            "score": puntaje,
            "date": date
        ]

        print("Este es el id que buscamos", id)
        AF.request(url, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("✅ Puntaje guardado con éxito.")
                case .failure(let error):
                    print("❌ Error al guardar puntaje: \(error)")
                    if let data = response.data,
                       let mensaje = String(data: data, encoding: .utf8) {
                        print("📩 Respuesta Supabase:\n\(mensaje)")
                    }
                }
            }
    }

    
    func mostrarAyuda() {
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
        
        let alerta = UIAlertController(title: "Ayuda para \(juegoElegido ?? "")", message: mensajeAyuda, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPokerVC" {
            if let destino = segue.destination as? pokerViewController {
                destino.jugador1 = nombreUsuario
            }
        } else if segue.identifier == "goToTocadoVC" {
            if let destino = segue.destination as? tocameViewController {
                destino.nombreJugador = nombreUsuario
            }
        } else if segue.identifier == "goToMisPuntajesVC" {
            if let destino = segue.destination as? MisPuntajesViewController {
                print("username que se envía a MisPuntajesViewController: \(nombreUsuario ?? "nil")")
                destino.username = nombreUsuario
            }
        }
    }
}


extension homeViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
      pageControlView.currentPage = pageIndex
    if pageIndex < juegos.count {
        juegoElegido = juegos[pageIndex]
        print("Juego seleccionado: \(juegoElegido ?? "ninguno")")
    }
  }
}

