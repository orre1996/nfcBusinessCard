//
//  ViewController.swift
//  NfcBusinessCard
//
//  Created by Oscar Berggren on 2020-06-22.
//  Copyright © 2020 Oscar Berggren. All rights reserved.
//

import UIKit
import CoreNFC

class StartPageViewController: UIViewController {

    var nfcSession: NFCNDEFReaderSession?
    var word = "None"
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func NfcButtonPressed(_ sender: UIButton) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
}

extension StartPageViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        
        messages.forEach({ message in
            message.records.forEach({ record in
                result += String.init(data: record.payload.advanced(by: 3), encoding: .utf8) ?? ""
            })
        })
        
        DispatchQueue.main.async { [weak self] in
            
            let storyboard = UIStoryboard(name: "BusinessCardViewController", bundle: nil)
            let businessCardViewController = storyboard.instantiateViewController(identifier: "businessCard") as! BusinessCardViewController
            businessCardViewController.nfcInformation = result
            businessCardViewController.modalPresentationStyle = .fullScreen
            self?.show(businessCardViewController, sender: self)
            
        }
    }
}

