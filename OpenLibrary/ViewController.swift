//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Francisco Humberto Andrade Gonzalez on 16/01/16.
//  Copyright © 2016 Francisco Humberto Andrade Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var imgPortada: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblAutores: UILabel!
    @IBOutlet weak var labelAutores: UILabel!
    @IBOutlet weak var labelTitulo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtISBN.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buscarISBN(sender: UITextField){
        sender.resignFirstResponder()

        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + sender.text!
        let url = NSURL(string: urls)

        let datos = NSData(contentsOfURL: url!)
        if datos != nil {
            do {
                //let json = NSString(data:datos!, encoding: NSUTF8StringEncoding)
                //self.tvDescripcion.text = String(json)
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                let dico2 = dico1["ISBN:" + sender.text!] as! NSDictionary
                self.lblTitulo.text = dico2["title"] as! NSString as String
                let autores = dico2["authors"] as? [[String : String]]
                if autores != nil {
                    self.lblAutores.text = ""
                    for autor in autores! {
                        let nombreDelAutor = autor["name"]
                        self.lblAutores.text?.appendContentsOf(nombreDelAutor!)
                        if autores!.count > 1 {
                            self.lblAutores.text?.appendContentsOf(" & ")
                        }
                    }
                }
                labelTitulo.text = "Título"
                if autores?.count > 1 {
                    labelAutores.text = "Autores"
                } else if autores == nil {
                    labelAutores.text = ""
                } else {
                    labelAutores.text = "Autor"
                }
                if dico2["cover"] != nil {
                    let dico3 = dico2["cover"] as! NSDictionary
                    if let url = NSURL(string: dico3["medium"] as! NSString as String) {
                        if let data = NSData(contentsOfURL: url) {
                            imgPortada.image = UIImage(data: data)
                            imgPortada.sizeToFit()
                        }
                    }
                }
                
            } catch _ {
                alertaDeError("Ha ocurrido un error con el origen de datos.")
            }

        } else {
            alertaDeError("Ha habido un error al tratar de obtener la información relacionada al ISBN. Verifica tu conexión a internet.")
        }
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        txtISBN.resignFirstResponder()
    }
    
    func alertaDeError(mensaje: String){
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            alerta.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    @IBAction func ocultaResultados(sender: AnyObject) {
        if self.txtISBN.text == "" {
            labelTitulo.text = ""
            lblTitulo.text = ""
            labelAutores.text = ""
            lblAutores.text = ""
            imgPortada.image = nil
        }
    }
}

