//
//  OnboardingVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/27.
//
import UIKit

class OnboardingVC: UIPageViewController{
    @DefaultsState(\.isNotFirst) var isNotFirst
    var list:[UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        list = [FirstVC(),FirstVC(),FirstVC()]
        self.delegate = self
        self.dataSource = self
        guard let first = list.first else {return}
        setViewControllers([first], direction: .forward, animated: true)
    }
}
extension OnboardingVC: UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currIdx = list.firstIndex(of: viewController) else {return nil}
        let prevIdx = currIdx - 1
        return prevIdx < 0 ? nil : list[prevIdx]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currIdx = list.firstIndex(of: viewController) else {return nil}
        let nextIdx = currIdx + 1
        return nextIdx >= list.count ? nil : list[nextIdx]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        list.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = list.firstIndex(of: first) else {return 0}
        return index
    }
}

