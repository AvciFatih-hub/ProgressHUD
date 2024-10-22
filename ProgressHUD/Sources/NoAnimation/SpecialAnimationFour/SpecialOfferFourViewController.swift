
import UIKit
import ScreenShield

protocol SpecialAnimationDelegate: AnyObject {
    func buttonTapped()
}

class SpecialOfferFourViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bottomLabel = UILabel()
    private let topLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let bottomView = BottomCustomView()
//    private let networkManager = NetworkManager()
    private var data: [(String, String)] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let model: DataOfferObject?
    
    weak var delegate: SpecialAnimationDelegate?
    
    init(_ model: DataOfferObject? = nil, delegate: SpecialAnimationDelegate) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        bottomView.model = self.model
        data = model?.objectTwo?.center.items.map({ ($0.name ?? "", $0.res ?? "") }) ?? []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        
        bottomView.buttonTapped = { [weak self] in
//            guard let selectedTariff = Storage.allTariffs?.first else { return }
            
            self?.bottomView.actionButton.isEnabled = false
            self?.delegate?.buttonTapped()
        }
        
        ScreenShield.shared.protect(view: self.bottomLabel)
        ScreenShield.shared.protect(view: self.topLabel)
        ScreenShield.shared.protect(view: self.tableView)
        ScreenShield.shared.protectFromScreenRecording()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
 
    private func setupUI() {
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 247/255, alpha: 1)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contentView.addSubview(tableView)
        contentView.backgroundColor = .clear
        tableView.backgroundColor = .clear
        
        contentView.addSubview(bottomView)
        
        bottomLabel.text = model?.objectTwo?.center.footer_text
        bottomLabel.numberOfLines = 0
        bottomLabel.textColor = UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1)
        bottomLabel.font = .systemFont(ofSize: 14, weight: .medium)
        bottomLabel.textAlignment = .left
        contentView.addSubview(bottomLabel)
        
        topLabel.text = model?.objectTwo?.center.title
        topLabel.textColor = .black
        topLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        topLabel.textAlignment = .center
        contentView.addSubview(topLabel)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview()
        }
                
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-21)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.bottom.equalTo(bottomLabel.snp.top).offset(-5)
        }
    }
    
//    private func purchase(tarif: TariffObject) {
//        showProgressAction()
//        
//        networkManager.buyTarif(tarif: tarif) { [weak self] purchasedTarif, success, _ in
//            DispatchQueue.main.async {
//                self?.bottomView.actionButton.isEnabled = true
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

extension SpecialOfferFourViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let leftLabel = UILabel()
        
        leftLabel.textColor = .black
        leftLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        let rightLabel = UILabel()
        
        rightLabel.textColor = .red
        rightLabel.font = .systemFont(ofSize: 14, weight: .medium)
        leftLabel.text = data[indexPath.row].0
        rightLabel.text = data[indexPath.row].1
        rightLabel.textAlignment = .right
        
        cell.contentView.addSubview(leftLabel)
        cell.contentView.addSubview(rightLabel)
        
        leftLabel.snp.makeConstraints { make in
            make.leading.equalTo(cell.contentView.snp.leading).offset(16)
            make.centerY.equalTo(cell.contentView.snp.centerY)
            make.trailing.equalTo(rightLabel.snp.leading).offset(-5)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalTo(cell.contentView.snp.trailing).offset(-16)
            make.centerY.equalTo(cell.contentView.snp.centerY)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model?.objectTwo?.center.subtitle
    }
}