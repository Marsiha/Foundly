import UIKit
import SnapKit

enum FilterType {
    case lost
    case found
}

class HistoryViewController: UIViewController {

    private let lostButton = UIButton()
    private let foundButton = UIButton()
    private let tableView = UITableView()
    
    private var selectedFilter: FilterType = .lost
    private var historyItems = [HistoryItem]()
    private var allHistoryItems = [HistoryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupFilterButtons()
        setupTableView()
        setupTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        HistoryService.shared.fetchHistoryData { result in
            switch result {
            case .success(let item):
                self.allHistoryItems = item
                self.applyFilter()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func applyFilter() {
        switch selectedFilter {
        case .lost:
            historyItems = allHistoryItems.filter { $0.itemType == "lost_item" }
        case .found:
            historyItems = allHistoryItems.filter { $0.itemType == "found_item" }
        }
        
        tableView.reloadData()
    }
    
    @objc private func filterLostItems() {
        selectedFilter = .lost
        applyFilter()
    }

    @objc private func filterFoundItems() {
        selectedFilter = .found
        applyFilter()
    }
    
    private func setupTitle() {
        navigationItem.title = "FOUNDLY"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .foundlyPrimaryDark
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setupFilterButtons() {
        lostButton.setTitle("Потерянное", for: .normal)
        lostButton.backgroundColor = .purple
        lostButton.setTitleColor(.white, for: .normal)
        lostButton.layer.cornerRadius = 10
        lostButton.addTarget(self, action: #selector(filterLostItems), for: .touchUpInside)
        
        foundButton.setTitle("Найденное", for: .normal)
        foundButton.backgroundColor = UIColor.systemYellow
        foundButton.setTitleColor(.black, for: .normal)
        foundButton.layer.cornerRadius = 10
        foundButton.addTarget(self, action: #selector(filterFoundItems), for: .touchUpInside)
        
        view.addSubview(lostButton)
        view.addSubview(foundButton)
        
        lostButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(80)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        foundButton.snp.makeConstraints { make in
            make.top.equalTo(lostButton)
            make.leading.equalTo(lostButton.snp.trailing).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HistoryItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lostButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryItemTableViewCell
        let item = historyItems[indexPath.row]
        cell.configure(title: item.title, location: item.address, status: item.status, type: item.itemType, time: item.date, description: item.description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        190
    }
}
