import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarScanApi {
  static Future<String> scanB() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.DEFAULT);
    return barcodeScanRes;
  }
}
