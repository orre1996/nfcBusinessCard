//
//  BusinessCardViewController.swift
//  NfcBusinessCard
//
//  Created by Oscar Berggren on 2020-06-22.
//  Copyright © 2020 Oscar Berggren. All rights reserved.
//

import Foundation
import UIKit

class BusinessCardViewController: UIViewController {
    
    @IBOutlet var foldPageView: PageFoldViewController!
    @IBOutlet var businessCardFrontView: UIView!
    @IBOutlet var businessCardBackView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var roleLabel: UILabel!
    @IBOutlet var sloganLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var qrCodeImageView: UIImageView!
    @IBOutlet var screenShot: UIImageView!
    
    var nfcInformation: String?
    var isOpen = false
    
    let duration = 0.65
    var scale = 1.0
    
    var orientations = UIInterfaceOrientationMask.landscape
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self.orientations }
        set { self.orientations = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPersonalInformation()
        
        shimmer(view: businessCardFrontView)
        shimmer(view: businessCardBackView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        view.addGestureRecognizer(tapGesture)
        
        generateQrCode()
    }
    
    @objc private func tappedView() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        isOpen = !isOpen
        UIView.transition(with: businessCardBackView, duration: duration, options: transitionOptions, animations: nil)
        UIView.transition(with: businessCardFrontView, duration: duration, options: transitionOptions, animations: nil)
        
        Timer.scheduledTimer(withTimeInterval: duration/2, repeats: false, block: {_ in
            self.businessCardFrontView.isHidden = self.isOpen
            self.businessCardBackView.isHidden = !self.isOpen
        })
    }
    
    private func setPersonalInformation() {
        let informationArray = nfcInformation?.split(separator: "\\")
        
        companyLabel.text  = String(informationArray?[0] ?? "")
        sloganLabel.text   = String(informationArray?[1] ?? "")
        nameLabel.text     = String(informationArray?[2] ?? "")
        roleLabel.text     = String(informationArray?[3] ?? "")
        phoneLabel.text    = String(informationArray?[4] ?? "")
        emailLabel.text    = String(informationArray?[5] ?? "")
        websiteLabel.text  = String(informationArray?[6] ?? "")
        locationLabel.text = String(informationArray?[7] ?? "")
    }
    
    private func generateQrCode() {
        let qrText = "MECARD:N:\(nameLabel.text ?? "");TEL:\(phoneLabel.text ?? "");EMAIL:\(emailLabel.text ?? "");(0,1,C4DE);;;"
        
        let data = qrText.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "InputMessage")
        
        let ciImage = filter?.outputImage
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.transformed(by: transform)
        
        let image = UIImage(ciImage: transformImage!)
        qrCodeImageView.image = image
    }
    
    func shimmer(view: UIView) {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.02, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0.02)
        gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width*3, height: view.bounds.size.height)
        
        let lowerAlpha: CGFloat = 0.7
        let solid = UIColor(white: 1, alpha: 1).cgColor
        let clear = UIColor(white: 1, alpha: lowerAlpha).cgColor
        gradient.colors     = [ solid, solid, clear, clear, solid, solid ]
        gradient.locations  = [ 0,     0.3,   0.45,  0.55,  0.7,   1     ]
        
        let theAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        theAnimation.duration = 3
        theAnimation.repeatCount = Float.infinity
        theAnimation.autoreverses = false
        theAnimation.isRemovedOnCompletion = false
        theAnimation.fillMode = CAMediaTimingFillMode.forwards
        theAnimation.fromValue = -view.frame.size.width * 2
        theAnimation.toValue =  0
        gradient.add(theAnimation, forKey: "animateLayer")
        
        view.layer.mask = gradient
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        let shareText = "\(nameLabel.text ?? "")\n\(phoneLabel.text ?? "")\n\(emailLabel.text ?? "")\n\(websiteLabel.text ?? "")"
        
        DispatchQueue.main.async { [weak self] in
            let items: [Any] = [shareText]
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self?.view
            self?.present(activityController, animated: true)
        }
    }
}
