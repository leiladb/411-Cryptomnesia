import UIKit

class ProfileViewController: UIViewController {

    private let loggedValue = UILabel()
    private let ratingValue = UILabel()
    private let friendsValue = UILabel()
    private let goalLabel = UILabel()
    private let goalProgress = UIProgressView(progressViewStyle: .default)
    private let yearlyGoal = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
    }

    private func setupLayout() {
        let avatar = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        avatar.tintColor = .systemIndigo
        avatar.contentMode = .scaleAspectFit
        avatar.heightAnchor.constraint(equalToConstant: 100).isActive = true

        let nameLabel = UILabel()
        nameLabel.text = "Your Name"
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        nameLabel.textAlignment = .center

        let handleLabel = UILabel()
        handleLabel.text = "@yourhandle"
        handleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        handleLabel.textColor = .secondaryLabel
        handleLabel.textAlignment = .center

        let stats = UIStackView(arrangedSubviews: [
            makeStat(value: loggedValue, caption: "Logged"),
            makeStat(value: ratingValue, caption: "Avg Rating"),
            makeStat(value: friendsValue, caption: "Friends")
        ])
        stats.axis = .horizontal
        stats.distribution = .fillEqually

        goalLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        let publicLabel = UILabel()
        publicLabel.text = "Public profile"
        let publicSwitch = UISwitch()
        publicSwitch.isOn = true
        let publicRow = UIStackView(arrangedSubviews: [publicLabel, publicSwitch])
        publicRow.axis = .horizontal
        publicRow.alignment = .center

        let main = UIStackView(arrangedSubviews: [avatar, nameLabel, handleLabel, stats, goalLabel, goalProgress, publicRow])
        main.axis = .vertical
        main.spacing = 16
        main.setCustomSpacing(4, after: nameLabel)
        main.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(main)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            main.topAnchor.constraint(equalTo: guide.topAnchor, constant: 24),
            main.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            main.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20)
        ])
    }

    private func makeStat(value: UILabel, caption: String) -> UIStackView {
        value.font = UIFont.preferredFont(forTextStyle: .title1)
        value.textAlignment = .center
        let captionLabel = UILabel()
        captionLabel.text = caption
        captionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        captionLabel.textColor = .secondaryLabel
        captionLabel.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [value, captionLabel])
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }

    private func updateStats() {
        let items = SampleData.items
        loggedValue.text = "\(items.count)"
        if items.isEmpty {
            ratingValue.text = "-"
        } else {
            let avg = Double(items.map { $0.rating }.reduce(0, +)) / Double(items.count)
            ratingValue.text = String(format: "%.1f", avg)
        }
        friendsValue.text = "\(SampleData.friends.count)"
        goalLabel.text = "Yearly goal: \(min(items.count, yearlyGoal)) of \(yearlyGoal) logged"
        goalProgress.progress = min(Float(items.count) / Float(yearlyGoal), 1)
    }
}
