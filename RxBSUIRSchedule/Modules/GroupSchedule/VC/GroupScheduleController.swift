//
//  GroupScheduleController.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import UIKit
import RxSwift
import RxDataSources
import SwiftyJSON

class GroupScheduleController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel
    private var viewModel = GroupScheduleViewModel()
    
    // MARK: - Subviews
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var scheduleTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        config()
        bind()
    }
}

// MARK: - Bind
extension GroupScheduleController {
    private func bind() {
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        viewModel.output.groupSchedule
            .asObservable()
            .subscribe(onNext: { [weak self] days in
                print(days)
                DispatchQueue.main.async {
                    self?.scheduleTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.loadingState
            .asObservable()
            .subscribe(onNext: { [weak self] state in
                DispatchQueue.main.async {
                    switch state {
                    case .Loading:
                        self?.title = "Идет загрузка"
                        self?.navigationController?.setNavigationBarHidden(false, animated: true)
                    case .None:
                        self?.navigationController?.setNavigationBarHidden(true, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs() {
        groupTextField.rx.controlEvent(.allEditingEvents)
            .asObservable()
            .map({ [weak self] _ in
                guard let text = self?.groupTextField.text else { return "" }
                return text
            })
            .bind(to: viewModel.input.groupNumber)
            .disposed(by: disposeBag)
        
        findButton.rx.tap
            .bind(to: viewModel.input.find)
            .disposed(by: disposeBag)
    }
}

// MARK: - Config UI
extension GroupScheduleController {
    private func style() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Config
extension GroupScheduleController {
    private func config() {
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension GroupScheduleController:
    UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.scheduleItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.scheduleItems[section].scheduleForCurrentWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTableViewCell.identifier, for: indexPath) as? SubjectTableViewCell
        else { return UITableViewCell() }

        let schedule = viewModel.scheduleItems[indexPath.section].scheduleForCurrentWeek[indexPath.row]
        cell.configureCell(for: schedule)
        
        return cell
    }
    
    // Header for cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40.0))
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40.0))
        
        view.addSubview(title)
        
        view.backgroundColor = .clear
        
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        title.textAlignment = .center
        
        let text = viewModel.scheduleItems[section].weekDay ?? ""
        
        title.text = text
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

}
