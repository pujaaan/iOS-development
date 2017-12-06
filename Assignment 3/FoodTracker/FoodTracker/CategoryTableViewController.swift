
import UIKit

class CategoryTableViewController:
UITableViewController {
    
    var categories = [String]()
    var identities = [String]()
    override func viewDidLoad() {
        
        identities = ["Food", "Drink"]
        tableView.delegate = self
        super.viewDidLoad()
        loadCategory()
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a category"
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let category = categories[indexPath.row]
        cell.categoryLabel.text = category

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Add cases here to move to different segues
        let vcName = identities[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
        

    private func loadCategory(){
        let category1 = "Food"
        let category2 = "Drink"
        
        categories += [category1, category2]
        
        
    }
}
