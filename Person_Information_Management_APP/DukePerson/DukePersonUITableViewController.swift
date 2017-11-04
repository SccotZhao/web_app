// * Custom Table View Cell

// 1. Design the new cell in Stroryboard
// 2. Create a subclass of UITableViewCell for the new cell
// 3. Update cell with UITabbleViewDataSource

// * delete Rows
// 1. Edit button on the right
// 2. Delete a row (in our data model)
// 3. Nice animation - move the table view rows up



// --


// * move rows around tableview
// 1. tell the tableview that you want to be able to move rows around
// 2. update the data model && update the tableview UI
import UIKit

class DukePersonUITableViewController: UITableViewController {
    
    var personLine : [PersonLine] = PersonLine.personLine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Duke Person App"
        
        navigationItem.leftBarButtonItem = editButtonItem
        
         loadInitialData()
    }
    
    func loadInitialData(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: UITableViewDataSource protocol , need 3 methods:  the section, number of row in each section, dequeue the resusable cells
    override  func numberOfSections(in tableView: UITableView) -> Int {
        return personLine.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personLine[section].persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonTableViewCell
        let personLineTemp = personLine[indexPath.section]
        let persons = personLineTemp.persons
        let person = persons[indexPath.row]
        cell.person = person
        
        return cell
    }
    //Set the header for each section
    //multiple sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let personLineTemp = personLine[section]
        
        return personLineTemp.name
    }
    
    //delete rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // 1 - delete the person from the personLine array
            let personLineTemp = personLine[indexPath.section]
            
            personLineTemp.persons.remove(at: indexPath.row)
            // 2 - update the table view with new data
            
            //tableView.reloadData() //bad way
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    //moving cells
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let personToMove = personLine[sourceIndexPath.section].persons[sourceIndexPath.row]
        
        //move personToMove to destination persons
        personLine[destinationIndexPath.section].persons.insert(personToMove, at: destinationIndexPath.row)
        //delete the personToMove from the source persons
        personLine[sourceIndexPath.section].persons.remove(at: sourceIndexPath.row)
        
    
    }
    
    // MARK : - UITableViewDelegate
    
    var selectedPerson : DukePerson?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personLineTemp = personLine[indexPath.section]
        let person = personLineTemp.persons[indexPath.row]
        
        selectedPerson = person
        
        performSegue(withIdentifier: "showPersonDetail", sender: nil)
        
    }
    
    // Mark : Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPersonDetail"{
            let personDetailTVC = segue.destination as! personDetailTableViewController
            personDetailTVC.person = selectedPerson
        }
    }

}
