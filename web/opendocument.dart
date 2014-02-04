import 'dart:html';

import 'package:archive/archive.dart';

Element resultDiv;
InputElement fileInput;

void main() {
  resultDiv = querySelector("#result");
  fileInput = querySelector("#file");
  
  fileInput.addEventListener("change", onFileChanged);
}

void onFileChanged(Event event) {
  FileList files = fileInput.files;
  var file = files.item(0);

  FileReader reader = new FileReader();
  reader.addEventListener("load", onZipLoaded);
  reader.readAsArrayBuffer(file);
}

void onZipLoaded(ProgressEvent event) {
  FileReader reader = event.currentTarget;
  
  var bytes = reader.result;  
  
  Archive archive = new ZipDecoder().decodeBytes(bytes);
  
  for (int i = 0; i < archive.numberOfFiles(); ++i) {
    String filename = archive.fileName(i);
    List<int> data = archive.fileData(i);
    if (filename == "content.xml") {
      String content = new String.fromCharCodes(data);
      
      resultDiv.text = content;
    }
  }
}