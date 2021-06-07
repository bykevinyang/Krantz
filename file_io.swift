import Foundation

//Function to read a text file (extra credit only)
func readTextFile(_ path: String)->(message: String, fileText: String?, lines: [String]){
  let text: String
  var textToReturn: [String] = []

  do {
    text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
  }
  catch {
    return ("\(error)", nil, [])
  }

  var lines = text.components(separatedBy:"\n")
  let _ = lines.popLast()

  for l in lines{
    let text = "add " + l
    textToReturn.append(text)
  }
  return ("", text, textToReturn)
}

//Function to write a text file (extra credit only)
func writeTextFile(_ path: String, data: String)->String? {
  do {
    // Write contents to file
    try data.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
  }
    catch let error as NSError {
    return "\(error)"
  }
  return nil
}
