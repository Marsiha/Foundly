import UIKit

class TermServiceViewController: UIViewController {
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.showsVerticalScrollIndicator = false
        tv.isSelectable = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .label
        tv.backgroundColor = .systemBackground
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupText()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Условия обслуживания"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupText() {
        textView.text = """
        Условия обслуживания

        Пожалуйста, внимательно прочитайте настоящие Условия обслуживания перед использованием мобильного приложения Foundly (далее — «Приложение»), разработанного с целью помощи пользователям в поиске и возврате потерянных вещей.

        1. Общие положения

        1.1. Настоящие Условия обслуживания регулируют отношения между пользователями и командой разработчиков приложения Foundly.
        1.2. Используя Приложение, пользователь подтверждает своё согласие с данными условиями. В случае несогласия с каким-либо из пунктов пользователь обязан прекратить использование Приложения.

        2. Регистрация и учетная запись

        2.1. Для доступа к основным функциям Приложения требуется регистрация и создание личного аккаунта.
        2.2. Пользователь обязуется предоставлять достоверную и актуальную информацию при регистрации.
        2.3. Пользователь несёт ответственность за сохранность своих учетных данных и за все действия, совершенные через его аккаунт.

        3. Использование приложения

        3.1. Приложение предоставляет пользователям возможность:
        — размещать объявления о потерянных и найденных предметах;
        — использовать интерактивную карту для поиска;
        — общаться с другими пользователями для организации возврата предметов.
        3.2. Запрещается использовать Приложение для распространения ложной информации, спама, мошенничества или иных неправомерных действий.

        4. Ответственность

        4.1. Команда Foundly не несет ответственности за действия пользователей, за достоверность размещённой ими информации, а также за фактический возврат предметов.
        4.2. Все взаимодействия между пользователями происходят на их личный риск.

        5. Интеллектуальная собственность

        5.1. Все элементы интерфейса, контент и программный код Приложения являются интеллектуальной собственностью команды Foundly и защищены законодательством.
        5.2. Копирование, распространение и использование элементов Приложения без разрешения запрещены.

        6. Изменения условий

        6.1. Команда оставляет за собой право изменять данные Условия обслуживания в любое время без предварительного уведомления.
        6.2. Обновлённые условия вступают в силу с момента их публикации в Приложении.

        7. Обратная связь

        Для вопросов, предложений и жалоб вы можете связаться с нами по электронной почте: 210103181@stu.sdu.edu.kz
        """
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
