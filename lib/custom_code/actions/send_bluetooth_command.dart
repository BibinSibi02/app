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
    // Start scanning for devices
    flutterBlue.scan(timeout: Duration(seconds: 4)); // Timeout after 4 seconds

    // Listen to scan results
    await for (ScanResult result in flutterBlue.scanResults) {
      if (result.device.name == 'Your_Raspberry_Pi_Name') {
        BluetoothDevice device = result.device;

        // Connect to the Raspberry Pi device
        await device.connect();
        print("Connected to Raspberry Pi!");

        // Discover services and characteristics
        List<BluetoothService> services = await device.discoverServices();
        BluetoothCharacteristic characteristic;

        for (var service in services) {
          for (var char in service.characteristics) {
            if (char.uuid.toString() == 'your-characteristic-uuid') {
              characteristic = char;
              break;
            }
          }
        }

        if (characteristic != null) {
          // Send lock/unlock command
          await characteristic.write(command.codeUnits);
          print("$command command sent successfully!");
        } else {
          print("Characteristic not found!");
        }

        // Disconnect after the operation
        await device.disconnect();
        break;
      }
    }
  } catch (e) {
    print("Bluetooth error: $e");
  }
}
