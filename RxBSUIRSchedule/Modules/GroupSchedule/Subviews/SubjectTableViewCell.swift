//
//  SubjectTableViewCell.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import UIKit
import RxSwift

class SubjectTableViewCell: UITableViewCell {
    
    public static let identifier: String = "SubjectTableViewCell"
    
    // MARK: - Propertie
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    private let subjectImageRx = PublishSubject<UIImage>()

    // MARK: - Subviews
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var subjectImageView: UIImageView!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var subjectPlaceLabel: UILabel!
    @IBOutlet weak var subjectWeeksLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        subjectImageRx
            .subscribe(onNext: { [weak self] image in
                DispatchQueue.main.async {
                    self?.subjectImageView.image = image
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        configure()
    }

    override func prepareForReuse() {
        subjectImageView.image = nil
    }
}

// MARK: - Private configuration
extension SubjectTableViewCell {
    
    private func configure() {
        self.backgroundColor = .clear
        
        parentView.backgroundColor = ProjectColors.mainWhiteColor
        parentView.layer.cornerRadius = 16.0
        
        subjectImageView.layer.cornerRadius = subjectImageView.frame.height / 2
    }
    
    @objc
    private func onSubjectImageTap() {
        
    }
}

// MARK: - Configure cell
extension SubjectTableViewCell {
    public func configureCell(for schedule: Schedule) {
        
        if let image = schedule.employee?.photoImage {
            self.subjectImageView.image = image
        } else if let imageUrlString = schedule.employee?.photoLink {
            if let imageUrl = URL(string: imageUrlString) {
                ImageLoader
                    .loadImage(from: imageUrl)
                    .subscribe(onSuccess: { [weak self] image in
                        self?.subjectImageRx.onNext(image)
                    },
                    onError: { [weak self] _ in
                        DispatchQueue.main.async {
                            self?.subjectImageView.backgroundColor = UIColor.clear
                        }
                    })
                    .disposed(by: disposeBag)
            }
        }
        
        subjectNameLabel.text = "\(schedule.subject ?? "") (\(schedule.lessonType?.rawValue ?? ""))"
        subjectPlaceLabel.text = schedule.auditory ?? ""
        
        var subjectWeeks = ""
        schedule.weekNumber?.forEach({ (week) in
            subjectWeeks.append("\(week) ")
        })
        
        subjectWeeksLabel.text = subjectWeeks
    }
}
