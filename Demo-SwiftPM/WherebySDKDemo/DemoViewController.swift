//
//  DemoViewController.swift
//  WherebySDKDemo
//
//  Created by Yuriy Pavlyshak on 06/07/2022.
//

import UIKit
import WherebySDK

/*
 This sample demonstrates two ways of adding a Whereby room that you can choose from:
 1. Embed the room view controller as a portion of your app's UI by adding it as a child.
 2. Push the room view controller in full screen in the app's main navigation stack
*/


// Replace with your room URL.
// See https://docs.whereby.com/creating-and-deleting-rooms for details on how to create rooms.
let roomUrl = URL(string: "https://team.whereby.com/ios")!

class DemoViewController: UIViewController {

    private enum RoomPresentationMethod {
        case embed
        case push
    }

    private var roomPresentationMethod: RoomPresentationMethod!
    private var embeddedRoomViewController: WherebyRoomViewController?
    @IBOutlet weak var topButtonsStackView: UIStackView!

    @IBAction func embedRoomButtonPressed(_ sender: UIButton) {
        roomPresentationMethod = .embed

        let roomConfig = createRoomConfig()
        let roomViewController = WherebyRoomViewController(config: roomConfig, isPushedInNavigationController: false)
        roomViewController.delegate = self

        // Add WherebyRoomViewController as a child view controller using standard UIKit API.
        // The steps are outlined below, see the documentation for more details:
        // https://developer.apple.com/documentation/uikit/view_controllers/creating_a_custom_container_view_controller

        // Add the room view controller as a child of this view controller
        addChild(roomViewController)
        view.addSubview(roomViewController.view)

        // Set up the auto layout constraints for the room view controller’s view.
        roomViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roomViewController.view.topAnchor.constraint(equalTo: topButtonsStackView.bottomAnchor, constant: 8),
            roomViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            roomViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            roomViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])

        // Notify the room view controller that the move is complete.
        roomViewController.didMove(toParent: self)

        roomViewController.join()
        embeddedRoomViewController = roomViewController
    }

    @IBAction func pushRoomButtonPressed(_ sender: UIButton) {
        roomPresentationMethod = .push

        let roomConfig = createRoomConfig()
        let roomViewController = WherebyRoomViewController(config: roomConfig, isPushedInNavigationController: true)
        roomViewController.delegate = self
        navigationController!.pushViewController(roomViewController, animated: true)
        roomViewController.join()
    }

    @IBAction func removeEmbeddedRoomButtonPressed(_ sender: UIButton) {
        removeEmbeddedRoomViewController()
    }

    private func createRoomConfig() -> WherebyRoomConfig {
        let roomConfig = WherebyRoomConfig(url: roomUrl)
        // Optional: set configuration parameters to customize the room, for example:
        // roomConfig.mediaMode = .audioOnly
        return roomConfig
    }

    private func removeEmbeddedRoomViewController() {
        embeddedRoomViewController?.willMove(toParent: nil)
        embeddedRoomViewController?.view.removeFromSuperview()
        embeddedRoomViewController?.removeFromParent()
        embeddedRoomViewController = nil
    }

}

// MARK: - WherebyRoomViewControllerDelegate

extension DemoViewController: WherebyRoomViewControllerDelegate {

    func roomViewControllerDidLeave(_ roomViewController: WherebyRoomViewController) {
        switch roomPresentationMethod! {
        case .embed:
            removeEmbeddedRoomViewController()
        case .push:
            navigationController!.popViewController(animated: true)
        }
    }

}
