import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mano1StackViews: UIStackView!
    @IBOutlet weak var mano2StackViews: UIStackView!
    @IBOutlet weak var jugarButton: UIButton!
    
    @IBOutlet weak var resultadoLabel: UILabel!
    
    // Datos del juego
    let cartasPoker = [
        "AS", "2S", "3S", "4S", "5S", "6S", "7S", "8S", "9S", "TS", "JS", "QS", "KS",
        "AC", "2C", "3C", "4C", "5C", "6C", "7C", "8C", "9C", "TC", "JC", "QC", "KC",
        "AH", "2H", "3H", "4H", "5H", "6H", "7H", "8H", "9H", "TH", "JH", "QH", "KH",
        "AD", "2D", "3D", "4D", "5D", "6D", "7D", "8D", "9D", "TD", "JD", "QD", "KD"
    ]

    let valoresJugadas: [String: Int] = [
        "Escalera de Color": 9, "Póker": 8, "Full": 7, "Color": 6,
        "Escalera": 5, "Trío": 4, "Doble Par": 3, "Par": 2, "Carta Alta": 1
    ]

    let valoresNumericos: [Character: Int] = [
        "A": 14, "K": 13, "Q": 12, "J": 11, "T": 10,
        "9": 9, "8": 8, "7": 7, "6": 6, "5": 5, "4": 4, "3": 3, "2": 2
    ]

    let emojisPalos: [Character: String] = [
        "S": "♠️", "H": "♥️", "C": "♣️", "D": "♦️"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        IniciarJuego()
    }
    
    func IniciarJuego() {
        let cartasMezcladas = cartasPoker.shuffled()
        let mano1 = Array(cartasMezcladas.prefix(5))
        let mano2 = Array(cartasMezcladas.dropFirst(5).prefix(5))

        let cartasProcesadas1 = procesarCartas(mano1)
        let cartasProcesadas2 = procesarCartas(mano2)

        let jugada1 = evaluarJugada(cartas: cartasProcesadas1)
        let jugada2 = evaluarJugada(cartas: cartasProcesadas2)

        // Limpiar cartas anteriores si hay
        mano1StackViews.arrangedSubviews.forEach { $0.removeFromSuperview() }
        mano2StackViews.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Mostrar cartas del Jugador 1
        for carta in mano1 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: carta)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2/3).isActive = true
            mano1StackViews.addArrangedSubview(imageView)
        }

        // Mostrar cartas del Jugador 2
        for carta in mano2 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: carta)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2/3).isActive = true
            mano2StackViews.addArrangedSubview(imageView)
        }

        // Mostrar el resultado
        let resultado =  determinarGanador(jugada1: jugada1, cartas1: cartasProcesadas1,
                                             jugada2: jugada2, cartas2: cartasProcesadas2)
            resultadoLabel.text = resultado
        
        // create the alert
        let alert = UIAlertController(title: "Resultado", message: resultado, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    func procesarCartas(_ cartas: [String]) -> [[String: Any]] {
        return cartas.map { carta in
            let valorChar = carta.first!
            let paloChar = carta.last!
            let valorNumerico = valoresNumericos[valorChar]!
            let paloEmoji = emojisPalos[paloChar] ?? "?"

            return [
                "original": carta,
                "valor": valorNumerico,
                "palo": String(paloChar),
                "emoji": paloEmoji
            ]
        }
    }

    func evaluarJugada(cartas: [[String: Any]]) -> String {
        let valoresOrdenados = cartas.map { $0["valor"] as! Int }.sorted()
        let palos = cartas.map { $0["palo"] as! String }
        let esColor = Set(palos).count == 1

        var conteoValores: [Int: Int] = [:]
        for valor in valoresOrdenados {
            conteoValores[valor, default: 0] += 1
        }
        let repeticiones = conteoValores.values.sorted(by: >)

        var esEscalera = true
        for i in 0..<valoresOrdenados.count - 1 {
            if valoresOrdenados[i] + 1 != valoresOrdenados[i + 1] {
                esEscalera = false
                break
            }
        }

        if esColor && esEscalera {
            return "Escalera de Color"
        } else if repeticiones == [4, 1] {
            return "Póker"
        } else if repeticiones == [3, 2] {
            return "Full"
        } else if esColor {
            return "Color"
        } else if esEscalera {
            return "Escalera"
        } else if repeticiones == [3, 1, 1] {
            return "Trío"
        } else if repeticiones == [2, 2, 1] {
            return "Doble Par"
        } else if repeticiones == [2, 1, 1, 1] {
            return "Par"
        } else {
            return "Carta Alta"
        }
    }

    func determinarGanador(jugada1: String, cartas1: [[String: Any]],
                           jugada2: String, cartas2: [[String: Any]]) -> String {
        let valor1 = valoresJugadas[jugada1] ?? 0
        let valor2 = valoresJugadas[jugada2] ?? 0

        if valor1 > valor2 {
            return "Ganó el Jugador 1 con \(jugada1)"
        } else if valor2 > valor1 {
            return "Ganó el Jugador 2 con \(jugada2)"
        } else {
            let valores1 = cartas1.map { $0["valor"] as! Int }.sorted(by: >)
            let valores2 = cartas2.map { $0["valor"] as! Int }.sorted(by: >)

            for i in 0..<5 {
                if valores1[i] > valores2[i] {
                    return "Empate en jugada, gana Jugador 1 por carta alta"
                } else if valores2[i] > valores1[i] {
                    return "Empate en jugada, gana Jugador 2 por carta alta"
                }
            }
            return "Empate total"
        }
    }
    
    @IBAction func jugarButtonTocado(_ sender: Any) {
        IniciarJuego()
    }
}
