import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var topHeadlienView: UIView!
    @IBOutlet weak var everythingView: UIView!
    @IBOutlet weak var favoritesView: UIView!
    
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        everythingView.alpha = 0
        favoritesView.alpha = 0
    }
    
    // MARK: Segment Control
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            topHeadlienView.alpha = 1
            everythingView.alpha = 0
            favoritesView.alpha = 0
        }
        else if(sender.selectedSegmentIndex == 1){
            topHeadlienView.alpha = 0
            everythingView.alpha = 1
            favoritesView.alpha = 0
        }
        else{
            topHeadlienView.alpha = 0
            everythingView.alpha = 0
            favoritesView.alpha = 1
        }
    }
    
}

