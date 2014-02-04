import 'dart:html';

import 'package:archive/archive.dart';

Element resultDiv;
InputElement fileInput;

void main() {
  resultDiv = querySelector("#result");
  fileInput = querySelector("#file");
  
  fileInput.addEventListener("change", onFileChanged);
}

void onFileChanged(var event) {
  FileList files = fileInput.files;
  var file = files.item(0);

  FileReader reader = new FileReader();
  reader.addEventListener("load", (fileEvent) {
    Archive archive = new ZipDecoder().decodeBytes(reader.result);

    for (int i = 0; i < archive.numberOfFiles(); ++i) {
      String filename = archive.fileName(i);
      List<int> data = archive.fileData(i);
      if (filename == "content.xml") {
        String content = new String.fromCharCodes(data);
        
        resultDiv.text = content;
      }
    }
  });
  
  reader.readAsArrayBuffer(file);
}