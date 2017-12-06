

import UIKit

class DrinkTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sample data.
        loadSampleMeals()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DrinkTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DrinkTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DrinkTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleMeals() {
        
        let photo1 = UIImage(named: "drink1")
        let photo2 = UIImage(named: "drink2")
        let photo3 = UIImage(named: "drink3")
        
        guard let meal1 = Meal(name: "Coke", photo: photo1, rating: 3) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Water", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let meal3 = Meal(name: "Red Wine", photo: photo3, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        
        meals += [meal1, meal2, meal3]
    }
    
}

