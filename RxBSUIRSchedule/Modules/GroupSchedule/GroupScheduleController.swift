//
//  GroupScheduleController.swift
//  RxBSUIRSchedule
//
//  Created by Artyom Batura on 10/7/20.
//

import UIKit
import RxSwift
import SwiftyJSON

class GroupScheduleController: UIViewController, Storyboarded {

    // MARK: - Properties
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    public let groupNumber = BehaviorSubject<Int>(value: 0)
    public let schedule = BehaviorSubject<[Day]>(value: [])
    
    // MARK: - Subviews
    @IBOutlet weak var subjectsTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        configure()
        
        // Rx subscriptions
        subscribeGroupNumber()
        subscribeSchedule()
    }
    
}

// MARK: - Rx subscriptions
extension GroupScheduleController {
    private func subscribeGroupNumber() {
        groupNumber
            .subscribe(onNext: { [weak self] group in
                self?.title = "№\(group)"
                self?.startFetchSchedule(forGroup: group)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeSchedule() {
        schedule
            .subscribe(onNext: { [weak self] (schedule) in
                DispatchQueue.main.async {
                    self?.subjectsTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Start fetch
extension GroupScheduleController {
    private func startFetchSchedule(forGroup group: Int) {
        APIRequests.getSchedule(group)
            .do(onSuccess: { [weak self] (_) in
                DispatchQueue.main.async {
                    self?.title = "№\(group)"
                    self?.refreshControl.endRefreshing()
                }
            },
            onSubscribe: { [weak self] in
                DispatchQueue.main.async {
                    self?.title = "Идет загрузка..."
                }
            })
            .subscribe { [weak self] (result) in
                self?.schedule.onNext(result)
            } onError: { [weak self] (error) in
                self?.showAllert(title: "Ошибка", message: "")
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Configure
extension GroupScheduleController {
    private func configure() {
        subjectsTableView.delegate = self
        subjectsTableView.dataSource = self
        
        self.view.backgroundColor = ProjectColors.mainGrayColor
        subjectsTableView.backgroundColor = ProjectColors.mainGrayColor
        
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление расписания")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        subjectsTableView.addSubview(refreshControl)
    }
}

// MARK: - Actions
extension GroupScheduleController {
    @objc
    private func refresh() {
        if let groupNumber = try? groupNumber.value() {
            startFetchSchedule(forGroup: groupNumber)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension GroupScheduleController:
    UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        do {
            return try schedule.value().count
        } catch {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let days = try schedule.value()
            return days[section].scheduleForCurrentWeek.count
        } catch {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTableViewCell.identifier, for: indexPath) as? SubjectTableViewCell,
            let schedule = try? schedule.value()
        else { return UITableViewCell() }

        let cellData = schedule[indexPath.section].scheduleForCurrentWeek[indexPath.row]
        cell.configureCell(for: cellData)
        
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
        
        do {
            let text = try schedule.value()[section].weekDay ?? ""
            title.text = text
        } catch {
            title.text = ""
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

}
