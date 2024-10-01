import UIKit
import Flutter
import CoreBluetooth

@UIApplicationMain
class AppDelegate: FlutterAppDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    var advertisementData: [String: Any]?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.bluetooth/advertise",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { (call, result) in
            if call.method == "startAdvertising" {
                if let args = call.arguments as? [String: Any],
                   let teamInfo = args["teamInfo"] as? String {
                    self.startAdvertising(with: teamInfo)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Expected team info", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func startAdvertising(with teamInfo: String) {
        let teamInfoData = teamInfo.data(using: .utf8)!
        let advertisementData = [
            CBAdvertisementDataLocalNameKey: "WithuTeamDevice",
            CBAdvertisementDataServiceUUIDsKey: [UUID().uuidString],
            CBAdvertisementDataManufacturerDataKey: teamInfoData
        ] as [String : Any]

        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        self.advertisementData = advertisementData
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager?.startAdvertising(advertisementData)
        } else {
            // Bluetooth is not available
            print("Bluetooth is not available.")
        }
    }
}

