import UIKit

class SubSubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var subsubcategories: [Subsubcategory] = []
    var onSelect: ((Subsubcategory) -> Void)?

    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subsubcategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let subsubcategory = subsubcategories[indexPath.row]
        cell.textLabel?.text = subsubcategory.name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSubsubcategory = subsubcategories[indexPath.row]
        onSelect?(selectedSubsubcategory)
        navigationController?.popToRootViewController(animated: true)
    }
}
