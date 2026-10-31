import UIKit

class AddEditViewController: UIViewController {

    var editingIndex: Int?

    private let titleField = UITextField()
    private let typeControl = UISegmentedControl(items: MediaType.allCases.map { $0.rawValue })
    private let ratingSlider = UISlider()
    private let ratingValueLabel = UILabel()
    private let notesView = UITextView()
    private let shareSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = editingIndex == nil ? "Add Entry" : "Edit Entry"
        setupLayout()
        loadExistingItem()

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // MARK: - Layout

    private func setupLayout() {
        titleField.placeholder = "e.g. Dune, Currents, Piranesi"
        titleField.borderStyle = .roundedRect
        titleField.returnKeyType = .done
        titleField.addTarget(titleField, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)

        typeControl.selectedSegmentIndex = 0

        ratingSlider.minimumValue = 1
        ratingSlider.maximumValue = 5
        ratingSlider.value = 3
        ratingSlider.addTarget(self, action: #selector(ratingChanged), for: .valueChanged)
        ratingValueLabel.text = "3 / 5"
        ratingValueLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true

        let ratingRow = UIStackView(arrangedSubviews: [ratingSlider, ratingValueLabel])
        ratingRow.axis = .horizontal
        ratingRow.spacing = 12
        ratingRow.alignment = .center

        notesView.font = UIFont.preferredFont(forTextStyle: .body)
        notesView.layer.borderColor = UIColor.separator.cgColor
        notesView.layer.borderWidth = 1
        notesView.layer.cornerRadius = 8
        notesView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        let shareLabel = makeLabel("Share with friends")
        shareLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let shareRow = UIStackView(arrangedSubviews: [shareLabel, shareSwitch])
        shareRow.axis = .horizontal
        shareRow.alignment = .center

        var config = UIButton.Configuration.filled()
        config.title = "Save"
        config.buttonSize = .large
        let saveButton = UIButton(configuration: config)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let form = UIStackView(arrangedSubviews: [
            makeLabel("Title"), titleField,
            makeLabel("Type"), typeControl,
            makeLabel("Rating"), ratingRow,
            makeLabel("Notes"), notesView,
            shareRow, saveButton
        ])
        form.axis = .vertical
        form.spacing = 10
        form.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(form)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            form.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            form.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            form.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20)
        ])
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }

    private func loadExistingItem() {
        guard let index = editingIndex else { return }
        let item = SampleData.items[index]
        titleField.text = item.title
        typeControl.selectedSegmentIndex = MediaType.allCases.firstIndex(of: item.type) ?? 0
        ratingSlider.value = Float(item.rating)
        ratingValueLabel.text = "\(item.rating) / 5"
        notesView.text = item.notes
        shareSwitch.isOn = item.isShared
    }

    // MARK: - Actions

    @objc private func ratingChanged() {
        let rounded = ratingSlider.value.rounded()
        ratingSlider.value = rounded
        ratingValueLabel.text = "\(Int(rounded)) / 5"
    }

    @objc private func saveTapped() {
        let name = (titleField.text ?? "").trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else {
            let alert = UIAlertController(title: "Missing title",
                                          message: "Please enter a title.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let date = editingIndex.map { SampleData.items[$0].date }
            ?? Date().formatted(date: .abbreviated, time: .omitted)
        let item = MediaItem(title: name,
                             type: MediaType.allCases[typeControl.selectedSegmentIndex],
                             rating: Int(ratingSlider.value.rounded()),
                             notes: notesView.text,
                             date: date,
                             isShared: shareSwitch.isOn)

        if let index = editingIndex {
            SampleData.items[index] = item
        } else {
            SampleData.items.insert(item, at: 0)
        }
        navigationController?.popViewController(animated: true)
    }
}

//code assisted by claude.ai
