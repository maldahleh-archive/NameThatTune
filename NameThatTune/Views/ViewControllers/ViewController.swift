//
//  ViewController.swift
//  NameThatTune
//
//  Created by Mohammed Al-Dahleh on 2017-12-15.
//  Copyright © 2017 Mohammed Al-Dahleh. All rights reserved.
//

import UIKit
import GameplayKit
import StoreKit

class ViewController: UIViewController {
    let developerToken = ""
    let urlSession: URLSession = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStartButton(to: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    func addStartButton(to view: UIView) {
        let button = UIButton(type: .system)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        button.setTitle("Play!", for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }
    
    @objc func startGame() {
        switch SKCloudServiceController.authorizationStatus() {
        case .authorized: requestCapabailities()
        case .notDetermined:
            SKCloudServiceController.requestAuthorization { [weak self] authorizationStatus in
                DispatchQueue.main.async {
                    self?.startGame()
                }
            }
        default: showNoGameMessage("We don't have permission to use your Apple Music library.")
        }
    }
    
    func requestCapabailities() {
        let controller = SKCloudServiceController()
        controller.requestCapabilities { capabilities, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if capabilities.contains(.musicCatalogPlayback) {
                    controller.requestStorefrontCountryCode { country, error in
                        if let countryCode = country {
                            self.fetchMusicWith(countryCode: countryCode)
                        } else {
                            self.showNoGameMessage("Unable to determine country code.")
                        }
                    }
                } else if capabilities.contains(.musicCatalogSubscriptionEligible) {
                    let subscribeController = SKCloudServiceSetupViewController()
                    
                    let options: [SKCloudServiceSetupOptionsKey: Any] = [
                        .action: SKCloudServiceSetupAction.subscribe,
                        .messageIdentifier: SKCloudServiceSetupMessageIdentifier.playMusic
                    ]
                    
                    subscribeController.load(options: options) { success, error in
                        if success {
                            self.present(subscribeController, animated: true)
                        } else {
                            self.showNoGameMessage(error?.localizedDescription ?? "Unknown error")
                        }
                    }
                } else {
                    self.showNoGameMessage("You aren't eligible to subscribe to Apple Music.")
                }
            }
        }
    }
    
    func fetchMusicWith(countryCode code: String) {
        var urlRequest = URLRequest(url: URL(string: "https://api.music.apple.com/v1/catalog/\(code)/charts?types=songs")!)
        urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let musicResult = try decoder.decode(MusicResult.self, from: data)
                    
                    if let songs = musicResult.results.songs.first?.data {
                        let shuffledSongs = (songs as NSArray).shuffled() as! [Song]
                        let gameController = PlayViewController()
                        gameController.songs = shuffledSongs
                        
                        self.present(gameController, animated: true)
                        return
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                self.showNoGameMessage("Unable to fetch data from Apple Music")
            }
        }
        
        task.resume()
    }
    
    func showNoGameMessage(_ message: String) {
        let alertController = UIAlertController(title: "Can't Play!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
