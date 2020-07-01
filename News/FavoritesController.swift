import Foundation
import UIKit


class FavoritesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var articles = [NSDictionary]()
    var timer = Timer()
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavorites()
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getFavorites), userInfo: nil, repeats: true)
    }
    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (articles.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesTableViewCell
        cell.title.text = articles[indexPath.row]["title"] as? String
        if (articles[indexPath.row]["description"] is NSNull){
            cell.desc.text = "Tap for more information."
        }
        else{
            cell.desc.text = articles[indexPath.row]["description"] as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath) as! FavoritesTableViewCell
        let defaults = UserDefaults.standard
        defaults.set(self.articles[indexPath.row]["url"], forKey: "ArticleUrl")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"DetailsController")
        self.present(viewController, animated: true)
    }
    
    // MARK: Get Favorites
    
    @objc func getFavorites(){
        let defaults = UserDefaults.standard
        if defaults.data(forKey: "Favorites") != nil{
            let decoded  = defaults.data(forKey: "Favorites")!
            articles = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [NSDictionary]
            tableView.reloadData()
        }
    }
    
}
