import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    var cryptoList = [Crypto]()
    let disposeBag = DisposeBag()
    
    let cryptoVM = CryptoViewModel()
    
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private func setupUI() {
           view.backgroundColor = .white
           
           tableView.delegate = self
           tableView.dataSource = self
           tableView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(tableView)
        
           activityIndicator.hidesWhenStopped = true
           activityIndicator.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
                   tableView.topAnchor.constraint(equalTo: view.topAnchor),
                   tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   
                   activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
               ])
           }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        cryptoVM.requestData()
        
       
    }
    
    private func setupBindings() {
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
                 self.cryptoList = cryptos
                 self.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { error in
                print(error)
            }.disposed(by: disposeBag)
        
   
        cryptoVM
            .loading
             .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }


}

