//
//  TableViewController.swift
//  ColeccionDeJuegosTarea
//
//  Created by Mac 17 on 5/18/21.
//  Copyright © 2021 deah. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var juegos: [JuegoTarea] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try juegos = context.fetch(JuegoTarea.fetchRequest())
            tableView.reloadData()
        } catch {
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return juegos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        let juego = juegos[indexPath.row]
        cell.imageGame.image = UIImage(data: (juego.imagen!))
        cell.imageGame.layer.cornerRadius = 20
        cell.labelName.text = juego.titulo
        cell.labelCategory.text = juego.categoria
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juegos.remove(at: indexPath.row))
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController?.popViewController(animated: true)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let btnUpdate = UITableViewRowAction(style: .normal, title: "Actualizar") {
         (actionRow, indexRow) in
            let juego = self.juegos[indexPath.row]
            self.performSegue(withIdentifier: "juegoSegue", sender: juego)
        }
        btnUpdate.backgroundColor = UIColor.systemBlue

        let btnDelete = UITableViewRowAction(style: .normal, title: "Eliminar") {
         (actionRow, indexRow) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(self.juegos.remove(at: indexPath.row))
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        btnDelete.backgroundColor = UIColor.red
        
        self.navigationController?.popViewController(animated: true)
        tableView.reloadData()

        return[btnUpdate, btnDelete]
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        juegos.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    @IBAction func deleteCell() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let siguienteVC = segue.destination as! JuegosViewController
         siguienteVC.juego = sender as? JuegoTarea
    }
}
