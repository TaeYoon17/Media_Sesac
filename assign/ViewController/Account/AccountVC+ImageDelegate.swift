//
//  AccountVC+ImageDelegate.swift
//  assign
//
//  Created by 김태윤 on 2023/09/02.
//

import UIKit
//MARK: -- AccountVC + Image Delegate
extension AccountVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        //        info[UIImagePickerController.InfoKey.originalImage]
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            DispatchQueue.main.async {[weak self] in
                self?.profileImage = image
                // TODO: - Here you get UIImage
            }
            dismiss(animated: true)
        }
    }
}
//MARK: -- 나중에 적용하기
//extension AccountVC: PHPickerViewControllerDelegate{
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        if let result = results.first{
//            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
//                guard let image = reading as? UIImage, error == nil else { return }
//                DispatchQueue.main.async {
//                    self.profileImage = image
//                    // TODO: - Here you get UIImage
//                }
//            }
//        }
//    }
//}
