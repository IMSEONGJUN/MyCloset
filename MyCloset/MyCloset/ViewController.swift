////
////  ViewController.swift
////  MyCloset
////
////  Created by SEONGJUN on 2020/01/31.
////  Copyright © 2020 Seongjun Im. All rights reserved.
////
//
//import UIKit
//import MobileCoreServices
//import Alamofire
//import Firebase
//import FirebaseStorage
//import FirebaseAuth
//import GoogleSignIn
//import SnapKit
//
//class ViewController: UIViewController {
//
//    let button = UIButton(type: .system)
//    let imageView = UIImageView()
//    let imagePicker = UIImagePickerController()
//    let takePictureButton = UIButton(type: .system)
//    let storage = Storage.storage()
//
//    override func loadView() {
//        super.loadView()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(named: "KeyColor")
//        imagePicker.delegate = self
//        // Do any additional setup after loading the view.
//
//        Auth.auth().signIn(withEmail: "panda@naver.com", password: "123456") { (result, err) in
//            if err == nil {
//                print("로그인 성공")
//                self.setupUI()
//            } else {
//                print(err as Any)
//            }
//        }
//    }
//
//    private func setupUI() {
//
//        imageView.contentMode = .scaleAspectFit
//
//        takePictureButton.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
//
//        takePictureButton.tintColor = .black
//        takePictureButton.addTarget(self, action: #selector(didTapTakePicture(_:)), for: .touchUpInside)
//
//        button.backgroundColor = .black
//
//
//
//        view.addSubview(imageView)
//        view.addSubview(takePictureButton)
//        view.addSubview(button)
//
//        setupConstraints()
//    }
//
//    private func setupConstraints() {
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        takePictureButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
//            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
//            takePictureButton.topAnchor.constraint(equalTo: imageView.bottomAnchor),
//            takePictureButton.heightAnchor.constraint(equalToConstant: 160),
//            takePictureButton.widthAnchor.constraint(equalToConstant: 160),
//            takePictureButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
//        ])
//
//        button.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(100)
//        }
//    }
//
//    @objc private func didTapTakePicture(_ sender: Any) {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {return}
//        imagePicker.sourceType = .camera
//
//        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)
//        imagePicker.mediaTypes = mediaTypes ?? []
//
//        present(imagePicker, animated: true)
//    }
//
//    private func storageSetUp() {
//        let meta = StorageMetadata()
//        meta.contentType = "image/jpeg"
//
//        let image = imageView.image
//        let data = image?.jpegData(compressionQuality: 0.1)
//        let storageRef = storage.reference().child("images/image1")
//
//        var imageURL = String()
//
//        storageRef.putData(data!, metadata: meta) { (_, error) in
//            if error == nil {
//                storageRef.downloadURL { (url, error) in
//                    if url != nil {
//                        imageURL = url!.absoluteString
//                        self.removeBG(url: imageURL)
//                    } else {
//                        print(error as Any)
//                    }
//                }
//            } else {
//                print(error)
//            }
//        }
//    }
//
//
//    private func removeBG(url: String) {
//        AF.request(
//                URL(string: "https://api.remove.bg/v1.0/removebg")!,
//                method: .post,
//                parameters: ["image_url": url], //firebase storage file URL
//                encoding: URLEncoding(),
//                headers: [
//                    "X-Api-Key": "H2Uf58yBG2yjnFD2mnKM7XhL"
//                ]
//        )
//            .responseData { imageResponse in
//                guard let imageData = imageResponse.data,
//                    let image = UIImage(data: imageData) else { return }
//
//                self.imageView.image = image
//        }
//    }
//}
//
//
//extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let mediaType = info[.mediaType] as! NSString
//        if UTTypeEqual(mediaType, kUTTypeImage) {
//            let originalImage = info[.originalImage] as! UIImage
//            let editedImage = info[.editedImage] as? UIImage
//            let selectedImage = editedImage ?? originalImage
//            imageView.image = selectedImage
//            storageSetUp()
//
//            if picker.sourceType == .camera {
//                UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
//            }
//        } else if UTTypeEqual(mediaType, kUTTypeMovie) {
//            if let mediaPath = (info[.mediaURL] as? NSURL)?.path, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaPath) {
//                if picker.sourceType == .camera {
//                    UISaveVideoAtPathToSavedPhotosAlbum(mediaPath, nil, nil, nil)
//                }
//            }
//        }
//        picker.dismiss(animated: true)
//    }
//}
