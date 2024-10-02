import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate,
                            CBPeripheralManagerDelegate {
    static let shared = BluetoothManager()
    
    private var centralManager: CBCentralManager?
    private var peripheralManager: CBPeripheralManager?
    private var advertisementData: [String: Any]?
    
    // Bluetooth 상태를 저장하기 위한 변수
    var isBluetoothEnabled: Bool {
        return centralManager?.state == .poweredOn
    }
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // CBCentralManagerDelegate 메서드
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on.")
            // Bluetooth가 켜졌을 때의 로직
        case .poweredOff:
            print("Bluetooth is powered off.")
            // Bluetooth가 꺼졌을 때의 로직
        case .resetting:
            print("Bluetooth is resetting.")
        case .unauthorized:
            print("Bluetooth is unauthorized.")
        case .unsupported:
            print("Bluetooth is unsupported on this device.")
        case .unknown:
            print("Bluetooth state is unknown.")
        @unknown default:
            fatalError()
        }
    }

    // 기타 Bluetooth 관련 메서드...
    
    func startAdvertising(with deviceUuid: String) {
        let uid = CBUUID(string: deviceUuid)
        print(uid)
        if isBluetoothEnabled {
            let advertisementData = [
                CBAdvertisementDataServiceUUIDsKey: [uid],
            ] as [String : Any]
            
            self.advertisementData = advertisementData
            peripheralManager?.startAdvertising(advertisementData)
        } else {
            print("Bluetooth is not enabled.")
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

    }
}

