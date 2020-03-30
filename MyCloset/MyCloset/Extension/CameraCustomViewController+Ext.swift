//
//  CameraCustomViewController+Ext.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/03/30.
//  Copyright © 2020 pandaman. All rights reserved.
//

import Foundation
import UIKit

extension CameraCustomViewController {
    func setupConstraints() {
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
}
