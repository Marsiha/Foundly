import UIKit

class SubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var subcategories: [Subcategory] = []
    var subsubcategories: [Subsubcategory] = []
    var onSelect: ((Subcategory, Subsubcategory) -> Void)?

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
        return subcategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let subcategory = subcategories[indexPath.row]
        cell.textLabel?.text = subcategory.name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSubcategory = subcategories[indexPath.row]
        let subsubcategoryVC = SubSubCategoryViewController()
        subsubcategoryVC.subsubcategories = subsubcategories.filter { $0.subcategory == selectedSubcategory.id }
        subsubcategoryVC.onSelect = { [weak self] selectedSubsubcategory in
            self?.onSelect?(selectedSubcategory, selectedSubsubcategory)
        }
        navigationController?.pushViewController(subsubcategoryVC, animated: true)
    }
}
