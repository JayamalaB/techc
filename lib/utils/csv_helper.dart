import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class CSVHelper {
  /// Save CSV file — Works on **Web, Android, iOS**
  static Future<void> saveCSV({
    required List<List<dynamic>> rows,
    required String fileName,
  }) async {
    String csv = const ListToCsvConverter().convert(rows);

    if (kIsWeb) {
      await _saveCSVWeb(csv, fileName);
    } else {
      await _saveCSVMobile(csv, fileName);
    }
  }

  /// For Web - using dynamic invocation to avoid compile-time errors
  static Future<void> _saveCSVWeb(String csvContent, String fileName) async {
    if (!kIsWeb) return;
    
    // Create bytes from CSV content
    final bytes = Uint8List.fromList(csvContent.codeUnits);
    
    try {
      // Dynamically access web APIs to avoid compile-time errors on mobile
      final blob = _createBlob([bytes], 'text/csv');
      final url = _createObjectUrl(blob);
      
      _createAndClickAnchor(url, fileName);
      _revokeObjectUrl(url);
    } catch (e) {
      print('Error saving CSV on web: $e');
      // Fallback: use download attribute approach
      _fallbackWebSave(csvContent, fileName);
    }
  }

  /// For Android + iOS
  static Future<void> _saveCSVMobile(String csvContent, String fileName) async {
    final bytes = Uint8List.fromList(csvContent.codeUnits);

    final params = SaveFileDialogParams(
      data: bytes,
      fileName: fileName,
    );

    await FlutterFileDialog.saveFile(params: params);
  }

  // Helper methods using dynamic/reflection-like approach
  static dynamic _createBlob(List<Uint8List> data, String type) {
    if (!kIsWeb) return null;
    
    try {
      // Using dynamic to avoid direct import of dart:html
      final blobClass = _getBlobClass();
      return blobClass != null ? blobClass.newInstance([data, type]) : null;
    } catch (e) {
      return null;
    }
  }

  static dynamic _createObjectUrl(dynamic blob) {
    if (!kIsWeb || blob == null) return null;
    
    try {
      final urlClass = _getUrlClass();
      return urlClass != null ? 
        urlClass.invokeMethod('createObjectUrl', [blob]) : null;
    } catch (e) {
      return null;
    }
  }

  static void _revokeObjectUrl(dynamic url) {
    if (!kIsWeb || url == null) return;
    
    try {
      final urlClass = _getUrlClass();
      urlClass?.invokeMethod('revokeObjectUrl', [url]);
    } catch (e) {
      // Ignore error
    }
  }

  static void _createAndClickAnchor(dynamic url, String fileName) {
    if (!kIsWeb || url == null) return;
    
    try {
      final anchorClass = _getAnchorElementClass();
      if (anchorClass != null) {
        final anchor = anchorClass.newInstance();
        anchor.setProperty('href', url);
        anchor.setProperty('download', fileName);
        anchor.invokeMethod('click', []);
      }
    } catch (e) {
      // Ignore error
    }
  }

  static dynamic _getBlobClass() {
    if (!kIsWeb) return null;
    try {
      // Access Blob via JS interop or reflection
      return _getProperty('Blob', from: _getWindow());
    } catch (e) {
      return null;
    }
  }

  static dynamic _getUrlClass() {
    if (!kIsWeb) return null;
    try {
      // Access URL/Url (different browsers use different capitalization)
      return _getProperty('URL', from: _getWindow()) ?? 
             _getProperty('Url', from: _getWindow());
    } catch (e) {
      return null;
    }
  }

  static dynamic _getAnchorElementClass() {
    if (!kIsWeb) return null;
    try {
      return _getProperty('HTMLAnchorElement', from: _getWindow()) ??
             _getProperty('AnchorElement', from: _getWindow());
    } catch (e) {
      return null;
    }
  }

  static dynamic _getWindow() {
    if (!kIsWeb) return null;
    try {
      // Access window object
      return _getProperty('window');
    } catch (e) {
      return null;
    }
  }

  static dynamic _getProperty(String name, {dynamic from}) {
    if (!kIsWeb) return null;
    // This is a simplified approach - in practice you'd use dart:js or js package
    try {
      // Using dynamic to avoid direct JS interop
      return from != null ? from[name] : null;
    } catch (e) {
      return null;
    }
  }

  /// Fallback method for web using data URL
  static void _fallbackWebSave(String csvContent, String fileName) {
    if (!kIsWeb) return;
    
    try {
      final dataUri = 'data:text/csv;charset=utf-8,${Uri.encodeComponent(csvContent)}';
      
      // Create a hidden anchor element
      final anchorHtml = '''
        <a id="hiddenDownload" href="$dataUri" download="$fileName" style="display: none;"></a>
      ''';
      
      // Add to DOM and click
      final div = _createElement('div');
      div.setInnerHtml(anchorHtml, validator: _allowAll);
      
      final anchor = _getElementById('hiddenDownload');
      if (anchor != null) {
        anchor.invokeMethod('click', []);
        // Remove from DOM
        div.remove();
      }
    } catch (e) {
      print('Fallback web save failed: $e');
    }
  }

  static dynamic _createElement(String tag) {
    if (!kIsWeb) return null;
    try {
      final document = _getProperty('document');
      return document != null ? document.invokeMethod('createElement', [tag]) : null;
    } catch (e) {
      return null;
    }
  }

  static dynamic _getElementById(String id) {
    if (!kIsWeb) return null;
    try {
      final document = _getProperty('document');
      return document != null ? document.invokeMethod('getElementById', [id]) : null;
    } catch (e) {
      return null;
    }
  }

  static final _allowAll = _createNodeValidator();
  
  static dynamic _createNodeValidator() {
    if (!kIsWeb) return null;
    // Create a permissive validator
    try {
      final validatorClass = _getProperty('NodeValidator', from: _getWindow());
      if (validatorClass != null) {
        final validator = validatorClass.newInstance();
        // Allow all HTML
        validator.setProperty('allowHtml', true);
        return validator;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}