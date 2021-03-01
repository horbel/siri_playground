//
//  ViewController.swift
//  siri_investigate
//
//  Created by Alexey Gorbel on 28.02.21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func readButton(_ sender: Any) {
        voiceText()
    }
    
    let synthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self;
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(attributedString: utterance.attributedSpeechString)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: characterRange)
        textView.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        textView.attributedText = NSAttributedString(attributedString: utterance.attributedSpeechString)
    }
    
    func voiceText(){
        let string = textView.text!
        let utterance = AVSpeechUtterance(attributedString: textView.attributedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
}

