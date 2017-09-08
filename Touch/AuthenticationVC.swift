

import UIKit
import LocalAuthentication

class AuthentocationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func useTouchIDButtonWasPressed(_ sender: Any) {
        let authenticationContext = LAContext()
        var error: NSError?
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Only humans  allowed. Sorry not dogs.", reply: { (success, error) in
                
                if success {
                    self.navigateToAuthenticatedVC()
                }else{
                    if let error = error as NSError?{
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                    }
                }
                
            })
        } else{
            showAlertViewForNoBiometrics()
            return
        }
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage(message: String){
        showAlertWithTitle(title: "Error", message: message)
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
        
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
        
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not ser on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts"
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
        }
        return message
    }
    
    func navigateToAuthenticatedVC(){
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "LoggedInVC"){
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(loggedInVC, animated: true)
            }
        }
    }

    func showAlertWithTitle(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showAlertViewForNoBiometrics() {
        showAlertWithTitle(title: "Error", message: "This device does not have a Touch ID sensor")
    }
}

