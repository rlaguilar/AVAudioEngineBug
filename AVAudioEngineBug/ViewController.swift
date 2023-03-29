import AVFoundation
import UIKit

class ViewController: UIViewController {
    let engine = AVAudioEngine()
    let format = AVAudioFormat(standardFormatWithSampleRate: 48000, channels: 2)!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        try! engine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: 1024)
        try! engine.start()

        let player = AVAudioPlayerNode()
        configureEngine(player: player, useVarispeed: true)
        player.play()

        print("Finished running")
    }

    func configureEngine(player: AVAudioPlayerNode, useVarispeed: Bool) {
        engine.attach(player)

        guard useVarispeed else {
            engine.connect(player, to: engine.mainMixerNode, format: format)
            return
        }

        let varispeed = AVAudioUnitVarispeed()
        engine.attach(varispeed)
        engine.connect(player, to: varispeed, format: format)
        engine.connect(varispeed, to: engine.mainMixerNode, format: format)
    }
}
