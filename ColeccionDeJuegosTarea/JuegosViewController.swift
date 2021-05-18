//
//  JuegosViewController.swift
//  ColeccionDeJuegosTarea
//
//  Created by Mac 17 on 5/18/21.
//  Copyright © 2021 deah. All rights reserved.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldCategory: UITextField!

    @IBOutlet weak var btnAddUpdate: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    let categories = ["Naturaleza", "Fondos", "Flores", "Playa", "Ríos"]
    
    var imagePicker = UIImagePickerController()
    var pickerView = UIPickerView()
    var juego: JuegoTarea? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        fieldCategory.inputView = pickerView
        
        if juego != nil {
            fieldName.text = juego!.titulo
            fieldCategory.text = juego!.categoria
            imageGame.image = UIImage(data: (juego!.imagen!) as Data)
            btnAddUpdate.setTitle("Actualizar", for: .normal)
        } else {
            btnDelete.isHidden = true
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fieldCategory.text = categories[row]
        fieldCategory.resignFirstResponder()
    }

    @IBAction func onPressGallery(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onPressAdd(_ sender: Any) {
        if juego != nil {
            juego!.imagen = imageGame.image?.jpegData(compressionQuality: 0.50)
            juego!.titulo = fieldName.text
            juego!.categoria = fieldCategory.text
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = JuegoTarea(context: context)
            juego.titulo = fieldName.text
            juego.categoria = fieldCategory.text
            juego.imagen = imageGame.image?.jpegData(compressionQuality: 0.50)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPressDelete(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageSelected = info[.originalImage] as? UIImage
        imageGame.image = imageSelected
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
