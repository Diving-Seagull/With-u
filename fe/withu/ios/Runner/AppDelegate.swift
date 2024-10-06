import UIKit
import Flutter
import FirebaseCore
import CoreBluetooth

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
//    var centralManager: CBCentralManager!
//    var peripheralManager: CBPeripheralManager?
//    var advertisementData: [String: Any]?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.initialize()
        
        GeneratedPluginRegistrant.register(with: self)
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.divingseagull.withu/advertise",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { (call, result) in
            if call.method == "startAdvertising" {
                if let args = call.arguments as? [String: Any],
                   let deviceUuid = args["deviceUuid"] as? String {
                    BluetoothManager.shared.startAdvertising(with: deviceUuid)
//                    self.startAdvertising(with: deviceUuid)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Expected Device Uuid", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

//        func centralManagerDidUpdateState(_ central: CBCentralManager) {
//            switch central.state {
//            case .poweredOn:
//                print("Bluetooth is powered on")
//                // Bluetooth 스캔을 시작할 수 있습니다.
//            case .poweredOff:
//                print("Bluetooth is powered off")
//            case .resetting:
//                print("Bluetooth is resetting")
//            case .unauthorized:
//                print("Bluetooth is unauthorized")
//            case .unsupported:
//                print("Bluetooth is unsupported")
//            case .unknown:
//                print("Bluetooth state is unknown")
//            @unknown default:
//                print("A new state has been added that we don't know about yet.")
//            }
//        }
//
//
//    private func startAdvertising(with deviceUuid: String) {
//        let advertisementData = [
////            CBAdvertisementDataLocalNameKey: "WithuTeamDevice",
//            CBAdvertisementDataServiceUUIDsKey: [deviceUuid],
//        ] as [String : Any]
//
//        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//        self.advertisementData = advertisementData
//    }
//    
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        if peripheral.state == .poweredOn {
//            peripheralManager?.startAdvertising(advertisementData)
//        } else {
//            // Bluetooth is not available
//            print("Bluetooth is not available.")
//        }
//    }
}

