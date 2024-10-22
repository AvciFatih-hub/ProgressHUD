
import UIKit
import LocalAuthentication
import ScreenShield

class SpecialOfferThreeViewController: UIViewController {
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var linesLabel: UILabel = {
        let label = UILabel()
        label.text = (model?.objectTwo?.description.items_title ?? "") + createText()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let lowImageIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let lowLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 115/255, green: 199/255, blue: 0/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let model: DataOfferObject?
//    private let networkManager = NetworkManager()
    weak var delegate: SpecialAnimationDelegate?
    
    init(_ model: DataOfferObject? = nil, delegate: SpecialAnimationDelegate) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        
        ScreenShield.shared.protect(view: self.topImageView)
        ScreenShield.shared.protect(view: self.titleLabel)
        ScreenShield.shared.protect(view: self.subtitleLabel)
        ScreenShield.shared.protect(view: self.linesLabel)
        ScreenShield.shared.protect(view: self.lowImageIconView)
        ScreenShield.shared.protect(view: self.lowLabel)
        ScreenShield.shared.protect(view: self.actionButton)
        ScreenShield.shared.protectFromScreenRecording()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func createText() -> String {
        var text: String = ""
        
        model?.objectTwo?.description.items?.forEach {
            text.append("\n \($0)")
        }
        
        return text
    }

    private func setUI() {
        guard let mainUrl = URL(string: "https://checkerorganizerapp.com\(model?.objectTwo?.dark_blue.main_img ?? "")") else { return }
        
        topImageView.kf.setImage(with: mainUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
        titleLabel.text = model?.objectTwo?.dark_blue.title
        subtitleLabel.text = model?.objectTwo?.dark_blue.subtitle
        
        guard let smallUrl = URL(string: "https://checkerorganizerapp.com\(model?.objectTwo?.dark_blue.small_img ?? "")") else { return }
        
        lowImageIconView.kf.setImage(with: smallUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        lowLabel.text = model?.objectTwo?.dark_blue.footer_text
        
        hStack.addArrangedSubview(lowImageIconView)
        hStack.addArrangedSubview(lowLabel)
        
        actionButton.setTitle(model?.objectTwo?.dark_blue.btn_title?.uppercased(), for: .normal)
        actionButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        view.addSubview(topImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(linesLabel)
        view.addSubview(hStack)
        view.addSubview(actionButton)
    }
    
    private func setConstraints() {
        view.backgroundColor = UIColor(red: 29/255, green: 34/255, blue: 57/255, alpha: 1)
        
        topImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalTo(109)
            make.height.equalTo(97)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(topImageView.snp.bottom).offset(15)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        linesLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-45)
        }
        
        actionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(37)
            make.trailing.equalToSuperview().offset(-37)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.height.equalTo(50)
        }
        
        lowImageIconView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        hStack.snp.makeConstraints { make in
            make.bottom.equalTo(actionButton.snp.top).offset(-15)
            make.leading.equalToSuperview().offset(37)
            make.trailing.equalToSuperview().offset(-37)
        }
    }
    
    func showSingleButtonAlert() {
        let alert = UIAlertController(title: model?.objectTwo?.dark_blue.title, message: model?.objectTwo?.dark_blue.subtitle, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.showTwoButtonAlert()
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showTwoButtonAlert() {
        let authText = LAContext().biometricType.rawValue
        let alertMess = String(format: model?.objectTwo?.dark_blue.al_subtitle ?? "", authText)
        let alert = UIAlertController(title: model?.objectTwo?.dark_blue.al_title, message: alertMess, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
//            guard let selectedTariff = Storage.allTariffs?.first else { return }
            
            self?.actionButton.isEnabled = false
//            self?.purchase(tarif: selectedTariff)
            self?.delegate?.buttonTapped()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

    @objc private func buttonTap() {
        showSingleButtonAlert()
    }
    
//    private func purchase(tarif: TariffObject) {
//        showProgressAction()
//        
//        networkManager.buyTarif(tarif: tarif) { [weak self] purchasedTarif, success, _ in
//            DispatchQueue.main.async {
//                self?.actionButton.isEnabled = true
//            }
//            
//            if success {
//                self?.showSuccessAction()
//                Storage.saveCurrentTarif(purchasedTarif)
//                
//                DispatchQueue.main.async {
//                    let vc = ReslutAnimationViewContoller(self?.model)
//                    
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self?.showFailureAction()
//                }
//            }
//        }
//    }
    
//    private func showProgressAction() {
//        ProgressHUD.animate(interaction: false)
//    }
//    
//    private func showSuccessAction() {
//        ProgressHUD.success(interaction: false)
//    }
//    
//    private func showFailureAction() {
//        ProgressHUD.failed(interaction: false)
//    }
}

extension LAContext {
    enum BiometricType: String {
        case none = "faceID"
        case touchID = "TouchID"
        case faceID = "FaceID"
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        }
        
        return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}