import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let filterControl = UISegmentedControl()
    private let tableView = UITableView()
    private var visible: [(index: Int, item: MediaItem)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Media"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    // MARK: - Layout

    private func setupLayout() {
        let profileButton = makeButton(title: "Profile", symbol: "person.crop.circle", action: #selector(profileTapped))
        let friendsButton = makeButton(title: "Friends", symbol: "person.2", action: #selector(friendsTapped))

        let buttonRow = UIStackView(arrangedSubviews: [profileButton, friendsButton])
        buttonRow.axis = .horizontal
        buttonRow.distribution = .fillEqually
        buttonRow.spacing = 12

        let filterTitles = ["All"] + MediaType.allCases.map { $0.rawValue }
        for (i, name) in filterTitles.enumerated() {
            filterControl.insertSegment(withTitle: name, at: i, animated: false)
        }
        filterControl.selectedSegmentIndex = 0
        filterControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)

        let header = UIStackView(arrangedSubviews: [buttonRow, filterControl])
        header.axis = .vertical
        header.spacing = 12
        header.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MediaCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(header)
        view.addSubview(tableView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: guide.topAnchor, constant: 12),
            header.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

    private func makeButton(title: String, symbol: String, action: Selector) -> UIButton {
        var config = UIButton.Configuration.tinted()
        config.title = title
        config.image = UIImage(systemName: symbol)
        config.imagePadding = 6
        let button = UIButton(configuration: config)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Data

    private func reload() {
        let selected = filterControl.selectedSegmentIndex
        visible = SampleData.items.enumerated()
            .filter { selected == 0 || $0.element.type == MediaType.allCases[selected - 1] }
            .map { (index: $0.offset, item: $0.element) }
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc private func filterChanged() { reload() }

    @objc private func addTapped() {
        navigationController?.pushViewController(AddEditViewController(), animated: true)
    }

    @objc private func profileTapped() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }

    @objc private func friendsTapped() {
        navigationController?.pushViewController(FriendsViewController(), animated: true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visible.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        let item = visible[indexPath.row].item
        let stars = String(repeating: "★", count: item.rating) + String(repeating: "☆", count: 5 - item.rating)

        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = "\(item.type.rawValue)  \(stars)  \(item.date)"
        content.image = UIImage(systemName: item.type.symbolName)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AddEditViewController()
        vc.editingIndex = visible[indexPath.row].index
        navigationController?.pushViewController(vc, animated: true)
    }
}
