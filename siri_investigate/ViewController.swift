//
//  ViewController.swift
//  siri_investigate
//
//  Created by Alexey Gorbel on 28.02.21.
//

import UIKit
import AVFoundation
import MobileCoreServices
import PDFKit

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
        synthesizer.delegate = self
        documentPickerController.delegate = self
    }
    
    @IBAction func loadPdfClicked(_ sender: Any) {
        present(documentPickerController, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController,
                                didPickDocumentAt url: URL) {
        print(url);
        
        if let pdf = PDFDocument(url: url) {
            let pageCount = pdf.pageCount
            let documentContent = NSMutableAttributedString()

            for i in 1 ..< pageCount {
                guard let page = pdf.page(at: i) else { continue }
                guard let pageContent = page.attributedString else { continue }
                documentContent.append(pageContent)
            }
            
            textView.attributedText = documentContent
        }
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

