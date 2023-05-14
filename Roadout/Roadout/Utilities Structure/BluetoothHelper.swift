//
//  BluetoothHelper.swift
//  Roadout
//
//  Created by Mihnea on 5/14/23.
//

import Foundation
import CoreBluetooth

extension HomeViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            print("unknown case not covered by the Switch inside the bluetooth helper extension")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Identifier: 9026A476-986E-1CFC-057F-5C15E1A191EE
        if peripheral.identifier == UUID(uuidString: "9026A476-986E-1CFC-057F-5C15E1A191EE") {
            btBarrier = peripheral
            centralManager.stopScan()
            centralManager.connect(btBarrier)
            btBarrier.delegate = self
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.discoverServices(nil)
    }
}

extension HomeViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
      guard let characteristics = service.characteristics else { return }

      for characteristic in characteristics {
          if characteristic.properties.contains(.write) {
              btbarrierCharateristic = characteristic
          }
      }
    }
}
