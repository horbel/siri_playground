//
//  ViewController.swift
//  siri_investigate
//
//  Created by Alexey Gorbel on 28.02.21.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, AVSpeechSynthesizerDelegate, UIDocumentPickerDelegate {
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func readButton(_ sender: Any) {
        voiceText()
    }
    
    let synthesizer = AVSpeechSynthesizer()
    let manager = FileManager.default
    
    let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self;
    }
    
    @IBAction func loadPdfClicked(_ sender: Any) {
        documentPickerController.delegate = self
        present(documentPickerController, animated: true, completion: nil)
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL){
        print(url);
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

