import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(category: String?, status: String?)
}

class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?

    private let categoryTextField = UITextField()
    private let statusTextField = UITextField()
    private let applyButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Filter Options"

        categoryTextField.placeholder = "Enter category"
        categoryTextField.borderStyle = .roundedRect
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false

        statusTextField.placeholder = "Enter status"
        statusTextField.borderStyle = .roundedRect
        statusTextField.translatesAutoresizingMaskIntoConstraints = false

        applyButton.setTitle("Apply Filters", for: .normal)
        applyButton.backgroundColor = .systemBlue
        applyButton.layer.cornerRadius = 8
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)

        view.addSubview(categoryTextField)
        view.addSubview(statusTextField)
        view.addSubview(applyButton)

        NSLayoutConstraint.activate([
            categoryTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoryTextField.widthAnchor.constraint(equalToConstant: 250),

            statusTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusTextField.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20),
            statusTextField.widthAnchor.constraint(equalToConstant: 250),

            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 20),
            applyButton.widthAnchor.constraint(equalToConstant: 150),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func applyFilters() {
        let category = categoryTextField.text
        let status = statusTextField.text
        delegate?.didApplyFilters(category: category, status: status)
        dismiss(animated: true)
    }
}
