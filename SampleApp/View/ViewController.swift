//
//  ViewController.swift
//  Sample
//
//  Created by Prashant Bashishth on 27/08/23.
//

import UIKit

class ViewController: UIViewController, JokesPresenterViewProtocol {
    func reloadTableView() {
        self.reloadTable()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: JokesPresenter?

    override func viewDidLoad() {
           super.viewDidLoad()
           initView()
       
        self.configurePresenter()
       }
    
    private func configurePresenter() {
        presenter = JokesPresenter(presentor: self)
         }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.presenter?.fetchTimer?.invalidate()
    }

       func initView() {
           tableView.delegate = self
           tableView.dataSource = self
           tableView.allowsSelection = false
           tableView.register(JokeCell.nib, forCellReuseIdentifier: JokeCell.identifier)
       }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            if self.presenter?.jokesList.count ?? 0 > AppConstants.maxRowCount {
                self.tableView.deleteRows(at: [IndexPath(row: AppConstants.maxRowCount-1, section: 0)], with: .fade)
            }
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            self.tableView.endUpdates()
        }
        
    }

}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(AppConstants.maxRowCount, presenter?.jokesList.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JokeCell.identifier, for: indexPath) as? JokeCell else {
            return UITableViewCell()
        }
        cell.content.text = presenter?.jokesList[indexPath.row]
        return cell
    }
}
