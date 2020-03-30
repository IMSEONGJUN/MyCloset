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

protocol CameraCustomViewControllerDelegate: class {
    func reloadRequest()
    
}

class CameraCustomViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var isSelected = false
    var selectedButton = UIButton()
    
    weak var delegate: CameraCustomViewControllerDelegate?
    
    let takePictureBtn = UIButton()
    let cancelBtn = UIButton()
    let guideLine = UIImageView()
    
    let categorySelectBtn1 = UIButton(type: .custom)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "cameraBG")
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        setupUI()
        
    }

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    private func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(videoPreviewLayer)
    }
    
    private func setupUI() {
        
        previewView.backgroundColor = .orange
        
        takePictureBtn.setImage(UIImage(named: "takeBtn"), for: .normal)
        takePictureBtn.addTarget(self, action: #selector(didTakePhoto), for: .touchUpInside)
        
        cancelBtn.setImage(UIImage(named: "cancelBtn"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(didTapCancelBtn), for: .touchUpInside)
        
        
        captureImageView.contentMode = .scaleAspectFit
        
        guideLine.tintColor = .white
        
        
        categorySelectBtn1.setImage(UIImage(named: "normal"), for: .normal)
        categorySelectBtn1.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        categorySelectBtn1.adjustsImageWhenHighlighted = false
        categorySelectBtn1.adjustsImageWhenDisabled = false
        
        
        categoryLabel1.text = "Top"
        categoryLabel2.text = "Bottom"
        categoryLabel3.text = "Outer"
        categoryLabel4.text = "Shoes"
        categoryLabel5.text = "Cap"
        categoryLabel6.text = "Socks"
        categoryLabel7.text = "Bag"
        categoryLabel8.text = "Acc"
        
        categoryLabel1.textAlignment = .center
        categoryLabel2.textAlignment = .center
        categoryLabel3.textAlignment = .center
        categoryLabel4.textAlignment = .center
        categoryLabel5.textAlignment = .center
        categoryLabel6.textAlignment = .center
        categoryLabel7.textAlignment = .center
        categoryLabel8.textAlignment = .center
        
        categoryLabel1.textColor = UIColor(named: "textColor")
        categoryLabel2.textColor = UIColor(named: "textColor")
        categoryLabel3.textColor = UIColor(named: "textColor")
        categoryLabel4.textColor = UIColor(named: "textColor")
        categoryLabel5.textColor = UIColor(named: "textColor")
        categoryLabel6.textColor = UIColor(named: "textColor")
        categoryLabel7.textColor = UIColor(named: "textColor")
        categoryLabel8.textColor = UIColor(named: "textColor")
        
        categorySelectBtn2.setImage(UIImage(named: "normal"), for: .normal)
        categorySelectBtn2.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        categorySelectBtn2.adjustsImageWhenHighlighted = false
        categorySelectBtn2.adjustsImageWhenDisabled = false
        
        categorySelectBtn3.setImage(UIImage(named: "normal"), for: .normal)
        categorySelectBtn3.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        categorySelectBtn3.adjustsImageWhenHighlighted = false
        categorySelectBtn3.adjustsImageWhenDisabled = false
        
        categorySelectBtn4.setImage(UIImage(named: "normal"), for: .normal)
        categorySelectBtn4.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        categorySelectBtn4.adjustsImageWhenHighlighted = false
        categorySelectBtn4.adjustsImageWhenDisabled = false
        
        categorySelectBtn5.setImage(UIImage(named: "normal"), for: .normal)
        categorySelectBtn5.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        categorySelectBtn5.adjustsImageWhenHighlighted = false
        categorySelectBtn5.adjustsImageWhenDisabled = false
        
        categorySelectBtn6.setImage(UIImage(named: "normal"), for: .normal)
        categorySelectBtn6.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        categorySelectBtn6.adjustsImageWhenHighlighted = false
        categorySelectBtn6.adjustsImageWhenDisabled = false
        
        categorySelectBtn7.setImage(UIImage(named: "normal"), for: .normal)
        categorySelectBtn7.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        categorySelectBtn7.adjustsImageWhenHighlighted = false
        categorySelectBtn7.adjustsImageWhenDisabled = false
        
        categorySelectBtn8.setImage(UIImage(named: "normal"), for: .normal)
        categorySelectBtn8.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        categorySelectBtn8.adjustsImageWhenHighlighted = false
        categorySelectBtn8.adjustsImageWhenDisabled = false
        
        addPhotoBtn.setImage(UIImage(named: "addBtn"), for: .normal)
        addPhotoBtn.addTarget(self, action: #selector(didTapAddButton(sender:)), for: .touchUpInside)
        
        view.addSubview(previewView)
        view.addSubview(captureImageView)
        view.addSubview(takePictureBtn)
        view.addSubview(guideLine)
        view.addSubview(addPhotoBtn)
        view.addSubview(cancelBtn)
    view.addSubviews([categorySelectBtn1,categorySelectBtn2,categorySelectBtn3,categorySelectBtn4,categorySelectBtn5,categorySelectBtn6,categorySelectBtn7,categorySelectBtn8])
        
        view.addSubviews([
            categoryLabel1,
            categoryLabel2,
            categoryLabel3,
            categoryLabel4,
            categoryLabel5,
            categoryLabel6,
            categoryLabel7,
            categoryLabel8,
        ])
        setupConstraints()
    }
    
    @objc func didTapButton(sender: UIButton) {
        if selectedButton != sender {
            sender.setImage(UIImage(named: "selected"), for: .normal)
            selectedButton.setImage(UIImage(named: "normal"), for: .normal)
            guideLine.alpha = 0.5
            
            switch sender {
            case categorySelectBtn1:
                guideLine.image = UIImage(named: "top")
            case categorySelectBtn2:
                guideLine.image = UIImage(named: "bottom")
            case categorySelectBtn3:
                guideLine.image = UIImage(named: "outer")
            case categorySelectBtn4:
                guideLine.image = UIImage(named: "shoes")
            case categorySelectBtn5:
                guideLine.image = UIImage(named: "cap")
            case categorySelectBtn6:
                guideLine.image = UIImage(named: "socks")
            case categorySelectBtn7:
                guideLine.image = UIImage(named: "bag")
            case categorySelectBtn8:
                guideLine.image = UIImage(named: "acc")
            default:
                break
            }
            
            selectedButton = sender
        } else {
            sender.setImage(UIImage(named: "normal"), for: .normal)
            selectedButton = UIButton()
            
            guideLine.image = nil
        }
    }
    
    @objc private func didTapCancelBtn() {
        self.dismiss(animated: true)
    }
    
    private func setupConstraints() {
        previewView.snp.makeConstraints {
            $0.width.height.equalTo(view.frame.width)
            $0.center.equalToSuperview()
        }

        takePictureBtn.snp.makeConstraints {
            $0.top.equalTo(previewView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(view.snp.width).multipliedBy(0.5)
            $0.height.equalTo(70)
        }
        
        cancelBtn.snp.makeConstraints {
            $0.top.equalTo(takePictureBtn.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(view.snp.width).multipliedBy(0.5)
            $0.height.equalTo(70)
        }
        
        captureImageView.snp.makeConstraints {
            $0.top.equalTo(previewView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(5)
            $0.leading.equalTo(takePictureBtn.snp.trailing).offset(view.frame.width * 0.1)
        }
        
        guideLine.snp.makeConstraints {
            $0.top.leading.equalTo(previewView).offset(50)
            $0.bottom.trailing.equalTo(previewView).offset(-50)
        }

        categorySelectBtn1.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
        }
        
        categorySelectBtn2.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(categorySelectBtn1.snp.trailing).offset(27)
            $0.top.equalTo(categorySelectBtn1)
        }
        
        categorySelectBtn3.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(categorySelectBtn2.snp.trailing).offset(27)
            $0.top.equalTo(categorySelectBtn1)
        }
        
        categorySelectBtn4.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(categorySelectBtn3.snp.trailing).offset(27)
            $0.top.equalTo(categorySelectBtn1)
        }
        
        categorySelectBtn5.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(30)
            $0.top.equalTo(categorySelectBtn1.snp.bottom).offset(20)
        }
        
        categorySelectBtn6.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(categorySelectBtn5.snp.trailing).offset(27)
            $0.top.equalTo(categorySelectBtn5.snp.top)
        }
        
        categorySelectBtn7.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(categorySelectBtn6.snp.trailing).offset(27)
            $0.top.equalTo(categorySelectBtn5.snp.top)
        }
        
        categorySelectBtn8.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(categorySelectBtn7.snp.trailing).offset(27)
            $0.top.equalTo(categorySelectBtn5.snp.top)
        }
        
        addPhotoBtn.snp.makeConstraints {
            $0.top.equalTo(categorySelectBtn1).offset(20)
            $0.leading.equalTo(categorySelectBtn4.snp.trailing).offset(30)
            $0.width.height.equalTo(70)
        }
        
        categoryLabel1.snp.makeConstraints {
            $0.bottom.equalTo(categorySelectBtn1.snp.top)
            $0.centerX.equalTo(categorySelectBtn1)
            
        }
        categoryLabel2.snp.makeConstraints {
            $0.bottom.equalTo(categorySelectBtn2.snp.top)
            $0.centerX.equalTo(categorySelectBtn2)
        }
        categoryLabel3.snp.makeConstraints {
            $0.bottom.equalTo(categorySelectBtn3.snp.top)
            $0.centerX.equalTo(categorySelectBtn3)
        }
        categoryLabel4.snp.makeConstraints {
            $0.bottom.equalTo(categorySelectBtn4.snp.top)
            $0.centerX.equalTo(categorySelectBtn4)
        }
        categoryLabel5.snp.makeConstraints {
            $0.bottom.equalTo(categorySelectBtn5.snp.top)
            $0.centerX.equalTo(categorySelectBtn5)
        }
        categoryLabel6.snp.makeConstraints {
            $0.bottom.equalTo(categorySelectBtn6.snp.top)
            $0.centerX.equalTo(categorySelectBtn6)
        }
        categoryLabel7.snp.makeConstraints {
            $0.bottom.equalTo(categorySelectBtn7.snp.top)
            $0.centerX.equalTo(categorySelectBtn7)
        }
        categoryLabel8.snp.makeConstraints {
            $0.bottom.equalTo(categorySelectBtn8.snp.top)
            $0.centerX.equalTo(categorySelectBtn8)
        }
        
    }
     
    @objc private func didTakePhoto() {
        if selectedButton.imageView?.image != nil {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        } else {
            let alertController = UIAlertController(title: "오류", message: "카테고리를 체크해주세요", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)!
        captureImageView.contentMode = .scaleAspectFill
        storageSetUp(image: image)
        
    }
    
    private func storageSetUp(image: UIImage) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let data = image.jpegData(compressionQuality: 0.1)
        let storageRef = Storage.storage().reference().child("images/image1")
        
        var imageURL = String()
        
        storageRef.putData(data!, metadata: meta) { (_, error) in
            if let error = error {
                print(error)
            }
                
            storageRef.downloadURL { (url, error) in
                if url != nil {
                    imageURL = url!.absoluteString
                    self.removeBG(url: imageURL)
                } else {
                    print(error as Any)
                }
            }
        }
    }
    
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
    
    private func addToStorage(image: UIImage) {
        var filename = ""
        var filenum = 0
        let meta = StorageMetadata()
        meta.contentType = "image/png"
    
        switch selectedButton {
        case categorySelectBtn1:
            filename = "top"
            filenum = DataManager.shared.top.count
            DataManager.shared.top.updateValue(image, forKey: "\(filename)\(filenum)")
        case categorySelectBtn2:
            filename = "bottom"
            filenum = DataManager.shared.bottom.count
            DataManager.shared.bottom.updateValue(image, forKey: "\(filename)\(filenum)")
        case categorySelectBtn3:
            filename = "outer"
            filenum = DataManager.shared.outer.count
            DataManager.shared.outer.updateValue(image, forKey: "\(filename)\(filenum)")
        case categorySelectBtn4:
            filename = "shoes"
            filenum = DataManager.shared.shoes.count
            DataManager.shared.shoes.updateValue(image, forKey: "\(filename)\(filenum)")
        case categorySelectBtn5:
            filename = "cap"
            filenum = DataManager.shared.cap.count
            DataManager.shared.cap.updateValue(image, forKey: "\(filename)\(filenum)")
        case categorySelectBtn6:
            filename = "socks"
            filenum = DataManager.shared.socks.count
            DataManager.shared.socks.updateValue(image, forKey: "\(filename)\(filenum)")
        case categorySelectBtn7:
            filename = "bag"
            filenum = DataManager.shared.bag.count
            DataManager.shared.bag.updateValue(image, forKey: "\(filename)\(filenum)")
        case categorySelectBtn8:
            filename = "acc"
            filenum = DataManager.shared.acc.count
            DataManager.shared.acc.updateValue(image, forKey: "\(filename)\(filenum)")
        default:
            break
        }
        
        let data = image.pngData()
        let storageRef = Storage.storage().reference().child("items").child("\(filename)/").child("\(filename)" + "\(filenum).png")
        
        storageRef.putData(data!, metadata: meta) { (_, error) in
            if error == nil {
                self.delegate?.reloadRequest()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    private func removeBG(url: String) {
        AF.request(
            URL(string: "https://api.remove.bg/v1.0/removebg")!,
            method: .post,
            parameters: ["image_url": url], //firebase storage file URL
            encoding: URLEncoding(),
            headers: [
                "X-Api-Key": "vSGcwwowucw4kTKHwjJ4JxWz"
            ])
          .responseData { imageResponse in
                guard let imageData = imageResponse.data,
                      let image = UIImage(data: imageData) else { return }
                self.captureImageView.image = image
           }
    }
}
