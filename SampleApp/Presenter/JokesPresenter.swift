//
//  JokesPresenter.swift
//  SampleApp
//
//  Created by Prashant Bashishth on 27/08/23.
//

import Foundation

protocol JokesPresenterViewProtocol: AnyObject {
    func reloadTableView()
}

class JokesPresenter: NSObject {
    private var webService: WebServiceProtocol
    var fetchTimer: Timer?
    weak var jokesPresentor: JokesPresenterViewProtocol?
    
    var jokesList:[String] = [] {
        didSet {
            jokesPresentor?.reloadTableView()
        }
    }

    init(presentor: JokesPresenterViewProtocol, webService: WebServiceProtocol = WebService()) {
        jokesPresentor = presentor
        self.webService = webService
        super.init()
        self.getJokesFromUserDefault()
        self.fetchTimer = Timer.scheduledTimer(timeInterval: AppConstants.fetchInterval, target: self, selector: #selector(self.getJokes), userInfo: nil, repeats: true)
        self.getJokes()
        
    }
    
    @objc func getJokes() {
        webService.fetchJokes(){ [weak self] result in
            
            switch result {
            case .success(let jokes):
                self?.jokesList.insert(jokes, at: 0)
                self?.saveJokesInUserDefault()
            case .failure(let error):
                print("Error retrieving users: \(error.localizedDescription)")
            }
            
        }
    }
    
    func saveJokesInUserDefault(){
        do {
            let myData = try NSKeyedArchiver.archivedData(withRootObject: jokesList, requiringSecureCoding: false)
            UserDefaults.standard.set(myData, forKey: AppConstants.jokesDefault)
            UserDefaults.standard.synchronize()
        } catch let err {
            print("Error in saving jokes in user defaults --", err.localizedDescription)
        }
       
    }
    
    func getJokesFromUserDefault(){
        do {
            guard let jokesData = UserDefaults.standard.object(forKey: AppConstants.jokesDefault) as? NSData else { return }
            
            if let jokesList = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: jokesData as Data) as? [String] {
                self.jokesList = jokesList
                print("Jokes from user default ---", jokesList)
            }
        } catch let err {
            print("Error in fetching jokes from user defaults --", err.localizedDescription)
        }
       
    }

}
