import Foundation
import UIKit


class EverythingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var articles = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
    }
    
    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (articles.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EverythingCell", for: indexPath) as! EverythingTableViewCell
        cell.title.text = articles[indexPath.row]["title"] as? String
        if (articles[indexPath.row]["description"] is NSNull){
            cell.desc.text = "Tap for more information."
        }
        else{
            cell.desc.text = articles[indexPath.row]["description"] as? String
        }
        
        cell.addFavoritesButton.tag = indexPath.row
        cell.addFavoritesButton.addTarget(self, action: #selector(addFavoritesTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! EverythingTableViewCell
        let defaults = UserDefaults.standard
        defaults.set(self.articles[indexPath.row]["url"], forKey: "ArticleUrl")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"DetailsController")
        self.present(viewController, animated: true)
    }
    
    // MARK: Add Article to Favorites
    
    @objc func addFavoritesTapped(_ sender: UIButton){
        let article = articles[sender.tag]
        let defaults = UserDefaults.standard
        if defaults.data(forKey: "Favorites") != nil{
            let decoded  = defaults.data(forKey: "Favorites")!
            var favorites = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [NSDictionary]
            if (favorites.filter({ el in el as NSObject == article }).count == 0){
                favorites.append(article)
            }
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favorites)
            defaults.set(encodedData, forKey: "Favorites")
            defaults.synchronize()
        }
        else{
            var favorites = [NSDictionary]()
            favorites.append(article)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favorites)
            defaults.set(encodedData, forKey: "Favorites")
            defaults.synchronize()
        }
    }
    
    
    // MARK: Refresh Button
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        getNews()
    }
    
    
    // MARK: Get News
    
    @objc func getNews(){
        if Reachability.isConnectedToNetwork() == true {
            let url = URL(string: "http://newsapi.org/v2/everything?q=bitcoin&from=2020-06-01&sortBy=publishedAt&apiKey=e65ee0938a2a43ebb15923b48faed18d")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            //Get response
            let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                do{
                    if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                        DispatchQueue.main.async {
                            let articles = json["articles"] as! [NSDictionary]
                            self.articles = []
                            for i in articles{
                                self.articles.append(i)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                catch{
                    let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с сервером...", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            task.resume()
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
