//
//  CameraCustomViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import Firebase
import FirebaseStorage
import FirebaseAuth
import GoogleSignIn
import SnapKit
import AVFoundation


class CameraCustomViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Properties
    var selectedButton: UIButton? = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "selected"), for: .selected)
        btn.setImage(UIImage(named: "normal"), for: .normal)
        return btn
    }()
    
    let takePictureBtn = UIButton()
    let cancelBtn = UIButton()
    let guideLine = UIImageView()
    
    lazy var categorySelectBtns = [categorySelectBtn1, categorySelectBtn2, categorySelectBtn3, categorySelectBtn4,
                                   categorySelectBtn5, categorySelectBtn6, categorySelectBtn7, categorySelectBtn8]
    let categorySelectBtn1 = UIButton()
    let categorySelectBtn2 = UIButton()
    let categorySelectBtn3 = UIButton()
    let categorySelectBtn4 = UIButton()
    let categorySelectBtn5 = UIButton()
    let categorySelectBtn6 = UIButton()
    let categorySelectBtn7 = UIButton()
    let categorySelectBtn8 = UIButton()
    
    let categoryLabel1 = UILabel()
    let categoryLabel2 = UILabel()
    let categoryLabel3 = UILabel()
    let categoryLabel4 = UILabel()
    let categoryLabel5 = UILabel()
    let categoryLabel6 = UILabel()
    let categoryLabel7 = UILabel()
    let categoryLabel8 = UILabel()
    
    let addPhotoBtn = UIButton()
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    let previewView = UIView()
    let captureImageView = UIImageView()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "cameraBG")
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        configureCameraRelatedThings()
        configureCategoryButtons()
        configureCategoryLabels()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    
    // MARK: - Camera Feature Setup
    func setupCaptureSession() {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        } catch let error {
            print("Error Unable to initialize back camera: \(error.localizedDescription)")
        }
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(videoPreviewLayer)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)!
        captureImageView.contentMode = .scaleAspectFill
        storageSetUp(image: image)
    }
    
    
    // MARK: - Initial Setup
    private func configureCameraRelatedThings() {
        previewView.backgroundColor = .orange
        takePictureBtn.setImage(UIImage(named: "takeBtn"), for: .normal)
        takePictureBtn.addTarget(self, action: #selector(didTakePhoto), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "cancelBtn"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(didTapCancelBtn), for: .touchUpInside)
        addPhotoBtn.setImage(UIImage(named: "addBtn"), for: .normal)
        addPhotoBtn.addTarget(self, action: #selector(didTapAddButton(sender:)), for: .touchUpInside)
        
        captureImageView.contentMode = .scaleAspectFit
        guideLine.tintColor = .white
        view.addSubviews([previewView, captureImageView, takePictureBtn, guideLine, addPhotoBtn, cancelBtn])
    }
    
    func configureCategoryButtons() {
        view.addSubviews(categorySelectBtns)
        for (i,v) in categorySelectBtns.enumerated() {
            v.setImage(UIImage(named: "selected"), for: .selected)
            v.setImage(UIImage(named: "normal"), for: .normal)
            v.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            v.adjustsImageWhenHighlighted = false
            v.adjustsImageWhenDisabled = false
            v.tag = i + 1
        }
    }
    
    func configureCategoryLabels() {
        categoryLabel1.text = "Top"
        categoryLabel2.text = "Bottom"
        categoryLabel3.text = "Outer"
        categoryLabel4.text = "Shoes"
        categoryLabel5.text = "Cap"
        categoryLabel6.text = "Socks"
        categoryLabel7.text = "Bag"
        categoryLabel8.text = "Acc"
        
        [categoryLabel1, categoryLabel2, categoryLabel3, categoryLabel4, categoryLabel5,
        categoryLabel6, categoryLabel7, categoryLabel8].forEach({
            $0.textAlignment = .center
            $0.textColor = UIColor(named: "textColor")
            view.addSubview($0)
        })
    }
    
    func setGuideLineImage(sender: UIButton) {
        guideLine.alpha = 0.5
        guard let category = CategoryButtonType(rawValue: sender.tag) else { return }
        guideLine.image = UIImage(named: category.name)
    }
    
    
    // MARK: - API Service
    private func storageSetUp(image: UIImage) {
        APIManager.shared.uploadImageNotRemovedBackground(image: image) { [weak self] (result) in
            switch result {
            case .success(let url):
                self?.removeBG(url: url)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addToStorage(image: UIImage) {
        guard let category = CategoryButtonType(rawValue: selectedButton?.tag ?? -0) else { return }
        APIManager.shared.uploadImageRemovedBackground(image: image, category: category) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            
            NotificationCenter.default.post(name: Notifications.newImagePushed, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func removeBG(url: String) {
        AF.request(
            URL(string: "https://api.remove.bg/v1.0/removebg")!,
            method: .post,
            parameters: ["image_url": url], //firebase storage file URL
            encoding: URLEncoding(),
            headers: [
                "X-Api-Key": "iAX5QbYg4xMHpQV43QNRiRC9"
            ])
          .responseData { imageResponse in
                guard let imageData = imageResponse.data,
                      let image = UIImage(data: imageData) else { return }
                self.captureImageView.image = image
           }
    }
    
    
    // MARK: - Action Handler
    @objc private func didTapAddButton(sender: UIButton) {
        if self.captureImageView.image != nil {
            let image = self.captureImageView.image!
            addToStorage(image: image)
        } else {
            let alertController = UIAlertController(title: "기다려주세요", message: "사진의 배경을 지우고 있습니다", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func didTapButton(sender: UIButton) {
        if !sender.isSelected {
            categorySelectBtns.filter{ $0 != sender }
                              .forEach({ $0.isSelected = false})
            sender.isSelected = true
            selectedButton = sender
            setGuideLineImage(sender: sender)
        } else {
            sender.isSelected = false
            guideLine.image = nil
            selectedButton = nil
        }
    }
    
    @objc private func didTapCancelBtn() {
        self.dismiss(animated: true)
    }

    @objc private func didTakePhoto() {
        if !categorySelectBtns.allSatisfy({$0.isSelected == false}) {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        } else {
            let alertController = UIAlertController(title: "오류", message: "카테고리를 체크해주세요", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}


