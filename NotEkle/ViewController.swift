//
//  ViewController.swift
//  NotEkle
//
//  Created by Hüseyin Savaş on 7.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setInitView()
    }

    private func setInitView() {
        items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        
        guard let data = UserDefaults.standard.array(forKey: "items") as? [String] else { return }
            items = data
            tableView.reloadData()
    }
    
    @IBAction func clickAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Yeni Eleman", message: "Yeni not giriniz", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Not Yaz"
        }
        alert.addAction(UIAlertAction(title: "Kapat", style: .cancel))
        alert.addAction(UIAlertAction(title: "Kaydet", style: .destructive, handler: { [weak self] _ in
            if let textField = alert.textFields?.first, let input = textField.text, !input.isEmpty {
                DispatchQueue.main.async {
                    var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                    currentItems.append(input)
                    UserDefaults.standard.setValue(currentItems, forKey: "items")
                    
                    self?.items.append(input)
                    self?.tableView.reloadData()
                }
            }
        }))
        
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            UserDefaults.standard.set(items, forKey: "items")
        }
    }
}
