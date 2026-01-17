import UIKit
import Turbo
import WebKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var navigationController = UINavigationController()
    private lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "MyDayTurboNative"
        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        return session
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        visit(url: URL(string: "https://myday.ildarsafin.tech/dashboards")!)
    }

    private func visit(url: URL) {
        let viewController = VisitableViewController(url: url)
        navigationController.pushViewController(viewController, animated: true)
        session.visit(viewController)
    }
}

extension SceneDelegate: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        visit(url: proposal.url)
    }

    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        print("Failed to visit: \(error)")
    }

    func sessionWebViewProcessDidTerminate(_ session: Session) {
        session.reload()
    }
}
