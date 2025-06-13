import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categories: [Category] = []
    var subcategories: [Subcategory] = []
    var subsubcategories: [Subsubcategory] = []
    var onSelect: ((Category, Subcategory, Subsubcategory) -> Void)?
    
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        titleLabel.text = "Выберите категорию"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        view.addSubview(titleLabel)
    }
    
    
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func fetchData() {
        fetchCategories { [weak self] result in
            guard let self = self, let result = result else { return }
            self.categories = result.category
            self.subcategories = result.subcategory
            self.subsubcategories = result.subsubcategory
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchCategories(completion: @escaping (CategoryResponse?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("No token found in UserDefaults")
            completion(nil)
            return
        }
        
        let url = URL(string: "https://foundly.kz/item/create/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(CategoryResponse.self, from: data)
                completion(result)
            } catch {
                print("Decoding error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoryTableViewCell else {
                    return UITableViewCell()
                }
        let category = categories[indexPath.row]
        cell.configure(name: category.name, photo: category.photo)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        let subcategoryVC = SubCategoryViewController()
        subcategoryVC.subcategories = subcategories.filter { $0.category == selectedCategory.id }
        subcategoryVC.subsubcategories = subsubcategories
        subcategoryVC.onSelect = { [weak self] selectedSubcategory, selectedSubsubcategory in
            self?.onSelect?(selectedCategory, selectedSubcategory, selectedSubsubcategory)
            self?.navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(subcategoryVC, animated: true)
    }
}
