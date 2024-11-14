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
let roomUrlString = ""

class DemoViewController: UIViewController {

    private enum RoomPresentationMethod {
        case embed
        case push
    }

    private var roomPresentationMethod: RoomPresentationMethod!
    private var embeddedRoomViewController: WherebyRoomViewController? {
        didSet {
            updateActionButtonsStackView()
        }
    }
    
    @IBOutlet private weak var roomUrlTextField: UITextField! {
        didSet {
            roomUrlTextField.text = roomUrlString
        }
    }
    
    @IBOutlet private weak var topButtonsStackView: UIStackView!
    @IBOutlet private weak var actionButtonStackView: UIStackView! {
        didSet {
            updateActionButtonsStackView()
        }
    }
    
    @IBOutlet weak var microphoneButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    @IBAction func embedRoomButtonPressed(_ sender: UIButton) {
        roomPresentationMethod = .embed
        guard let roomURL = getRoomURL() else {
            return
        }
        let roomConfig = createRoomConfig(roomURL: roomURL)
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
        
        // Show/hide UI elements
//        embeddedRoomViewController?.setRoomInfoIsHidden(true)
//        embeddedRoomViewController?.setMoreButtonIsHidden(true)
//        embeddedRoomViewController?.setSettingsButtonIsHidden(true)
//        embeddedRoomViewController?.setRoomControlBarIsHidden(true)
        
        // Set room background color
        embeddedRoomViewController?.view.backgroundColor = .clear
        embeddedRoomViewController?.setRoomBackgroundColor(.clear)
    }

    @IBAction func pushRoomButtonPressed(_ sender: UIButton) {
        roomPresentationMethod = .push
        guard let roomURL = getRoomURL() else {
            return
        }
        let roomConfig = createRoomConfig(roomURL: roomURL)
        let roomViewController = WherebyRoomViewController(config: roomConfig, isPushedInNavigationController: true)
        roomViewController.delegate = self
        navigationController!.pushViewController(roomViewController, animated: true)
        roomViewController.join()
    }

    @IBAction func removeEmbeddedRoomButtonPressed(_ sender: UIButton) {
        guard let embeddedRoomViewController = embeddedRoomViewController else {
            return
        }
        embeddedRoomViewController.leaveRoom()
        removeEmbeddedRoomViewController()
    }

    @IBAction func toggleMicButtonPressed(_ sender: UIButton) {
        guard let embeddedRoomViewController = embeddedRoomViewController else { return }
        embeddedRoomViewController.isMicrophoneEnabled = !embeddedRoomViewController.isMicrophoneEnabled
    }
    
    @IBAction func toggleCamButtonPressed(_ sender: UIButton) {
        guard let embeddedRoomViewController = embeddedRoomViewController else { return }
        embeddedRoomViewController.isCameraEnabled = !embeddedRoomViewController.isCameraEnabled
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomUrlTextField.delegate = self
    }
    
    // MARK: Private
    
    private func updateActionButtonsStackView() {
        actionButtonStackView.isHidden = embeddedRoomViewController == nil
    }
    
    private func updateMicrophoneButtonTintColor(isMicrophoneEnabled: Bool) {
        microphoneButton.tintColor = isMicrophoneEnabled ? .green : .red
    }
    
    private func updateCameraButtonTintColor(isCameraEnabled: Bool) {
        cameraButton.tintColor = isCameraEnabled ? .green : .red
    }
    
    private func getRoomURL() -> URL? {
        guard let roomUrlStringInput = roomUrlTextField.text,
              let roomURL = URL(string: roomUrlStringInput) else {
            // Display an error
            return nil
        }
        return roomURL
    }
    
    private func createRoomConfig(roomURL: URL) -> WherebyRoomConfig {
        var roomConfig = WherebyRoomConfig(url: roomURL)
        // Optional: set configuration parameters to customize the room, for example:
        // roomConfig.mediaMode = .audioOnly
        roomConfig.skipRoomPushAnimation = true
        return roomConfig
    }

    private func removeEmbeddedRoomViewController() {
        embeddedRoomViewController?.willMove(toParent: nil)
        embeddedRoomViewController?.view.removeFromSuperview()
        embeddedRoomViewController?.removeFromParent()
        embeddedRoomViewController = nil
    }

}

// MARK: - UITextFieldDelegate

extension DemoViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - WherebyRoomViewControllerDelegate

extension DemoViewController: WherebyRoomViewControllerDelegate {
    
    func roomViewControllerDidJoinRoom(_ roomViewController: WherebySDK.WherebyRoomViewController) {
        updateMicrophoneButtonTintColor(isMicrophoneEnabled: roomViewController.isMicrophoneEnabled)
        updateCameraButtonTintColor(isCameraEnabled: roomViewController.isCameraEnabled)
    }
    
    func roomViewControllerDidUpdateMicrophoneEnabled(_ roomViewController: WherebySDK.WherebyRoomViewController, isMicrophoneEnabled: Bool) {
        updateMicrophoneButtonTintColor(isMicrophoneEnabled: isMicrophoneEnabled)
    }
    
    func roomViewControllerDidUpdateCameraEnabled(_ roomViewController: WherebySDK.WherebyRoomViewController, isCameraEnabled: Bool) {
        updateCameraButtonTintColor(isCameraEnabled: isCameraEnabled)
    }
    

    func roomViewControllerDidLeave(_ roomViewController: WherebyRoomViewController) {
        switch roomPresentationMethod! {
        case .embed:
            removeEmbeddedRoomViewController()
        case .push:
            navigationController!.popViewController(animated: true)
        }
    }

}

