// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_blue/flutter_blue.dart';

Future<void> sendBluetoothCommand(String command) async {
  // Initialize the Bluetooth instance
  FlutterBlue flutterBlue = FlutterBlue.instance;

  try {
    // Start scanning for devices with a timeout of 4 seconds
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results and check for the Raspberry Pi device
    bool deviceFound = false;
    await for (ScanResult result in flutterBlue.scanResults) {
      if (result.device.name == 'Your_Raspberry_Pi_Name') {
        BluetoothDevice device = result.device;

        // Stop scanning once the device is found
        flutterBlue.stopScan();

        // Connect to the Raspberry Pi device
        await device.connect();
        print("Connected to Raspberry Pi!");

        // Discover services and characteristics
        List<BluetoothService> services = await device.discoverServices();
        BluetoothCharacteristic? characteristic;

        // Find the specific characteristic for lock control
        for (var service in services) {
          for (var char in service.characteristics) {
            if (char.uuid.toString() == 'your-characteristic-uuid') {
              characteristic = char;
              break;
            }
          }
        }

        // Check if the characteristic was found
        if (characteristic != null) {
          // Send lock/unlock command
          await characteristic.write(command.codeUnits);
          print("$command command sent successfully!");
        } else {
          print("Characteristic not found!");
        }

        // Disconnect after the operation
        await device.disconnect();
        deviceFound = true;
        break;
      }
    }

    // If no device was found, print a message
    if (!deviceFound) {
      print("Raspberry Pi device not found.");
    }
  } catch (e) {
    print("Bluetooth error: $e");
  }
}
