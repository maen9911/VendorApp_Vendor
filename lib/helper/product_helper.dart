import 'dart:math' as math;

import 'package:sixvalley_vendor_app/features/product_details/enums/preview_type.dart';

class ProductHelper {


  static String removeSpacesAndLowercase(String input) {
    return input.replaceAll(' ', '').toLowerCase();
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  static String replaceUnderscoreWithHyphen(String input) {
    return input.replaceAll('_', '-');
  }

  static List<String> processList(List<String> inputList) {
    return inputList.map((str) => str.toLowerCase().trim()).toList();
  }

  static String generateSKU() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
    String sku = '';

    for (int i = 0; i < 6; i++) {
      sku += chars[random.nextInt(chars.length)];
    }
    return sku;
  }


  static PreviewType getFileType(String url) {
    if(url.contains('.pdf')) {
      return PreviewType.pdf;
    } else if(url.contains('.jpg') || url.contains('.jpeg') || url.contains('.png')) {
      return  PreviewType.image;
    } else if(url.contains('.mp4') || url.contains('.mkv') || url.contains('.avi') || url.contains('.flv') || url.contains('.mov') || url.contains('.wmv') || url.contains('.webm')) {
      return PreviewType.video;
    } else if ( url.contains('.mp3') || url.contains('.wav') || url.contains('.aac') || url.contains('.wma') || url.contains('.amr')) {
      return PreviewType.audio;
    }else {
      return PreviewType.others;
    }
  }

  static String getFileExtension(String fileName) {
    if (fileName.contains('.')) {
      return '.${fileName.split('.').last}';
    }
    return '';
  }



}