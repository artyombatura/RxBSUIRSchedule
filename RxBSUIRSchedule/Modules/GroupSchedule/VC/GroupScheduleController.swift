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

struct ScheduleSection {
    var header: String
    var items: [Item]
}

extension ScheduleSection: SectionModelType {
    typealias Item = Schedule
    
    init(original: ScheduleSection, items: [Schedule]) {
        self = original
        self.items = items
    }
}


class GroupScheduleController: UIViewController, Storyboarded {
    
    enum Constants {
        static var tableSectionHeightInHeader: CGFloat { return 40.0 }
        static var tableSectionLabelSizeInHeader: CGFloat { return 20.0 }
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<ScheduleSection> { (dataSource, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectTableViewCell", for: indexPath) as! SubjectTableViewCell
        cell.configureCell(for: item)
        return cell
    }
    
    // MARK: - ViewModel
    private var viewModel = GroupScheduleViewModel()
    
    // MARK: - Subviews
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var firstWeekButton: UIButton!
    @IBOutlet weak var secondWeekButton: UIButton!
    @IBOutlet weak var thirdWeekButton: UIButton!
    @IBOutlet weak var fifthWeekButton: UIButton!
    @IBOutlet weak var allWeeksButton: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        configDataSource()
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
            .map { (schedule) -> [ScheduleSection] in
                schedule.map { (day) -> ScheduleSection in
                    return ScheduleSection(header: day.weekDay ?? "",
                                           items: day.schedule ?? [Schedule]())
                }
            }
            .asObservable()
            .bind(to: scheduleTableView.rx.items(dataSource: dataSource))
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
        
        viewModel.output.networkError
            .asObservable()
            .subscribe(onNext: { [weak self] error in
                if let error = error as? APIError {
                    switch error {
                    case .NotFound:
                        self?.showAllert(title: "Расписание не найдено",
                                         message: "Проверьте номер группы и попробуйте снова")
                    default: break
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.onWeekChange
            .asObservable()
            .subscribe(onNext: { [weak self] week in
                if week != 0 {
                    self?.weekLabel.text = "Неделя \(week)"
                } else {
                    self?.weekLabel.text = "Все недели"
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
        
        firstWeekButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(1)
            })
            .disposed(by: disposeBag)
        
        secondWeekButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(2)
            })
            .disposed(by: disposeBag)
        
        thirdWeekButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(3)
            })
            .disposed(by: disposeBag)
        
        fifthWeekButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(4)
            })
            .disposed(by: disposeBag)
        
        allWeeksButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.weekNumber.accept(0)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Config UI
extension GroupScheduleController {
    private func style() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.yellow
        self.navigationController?.navigationBar.barTintColor = UIColor.yellow
    }
}

// MARK: - Config scheduleTableView
extension GroupScheduleController: UITableViewDelegate {
    private func configDataSource() {
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
    }
}
