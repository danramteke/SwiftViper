import Stencil
import StencilSwiftKit
import PathKit
import Commander
import Foundation



let lowerFirstWord: ((Any?) throws -> Any?) =  { (_ value: Any?) in
    let string = value as! String
    let cs = CharacterSet.uppercaseLetters
    let scalars = string.unicodeScalars
    let start = scalars.startIndex
    var idx = start
    while let scalar = UnicodeScalar(scalars[idx].value), cs.contains(scalar) && idx <= scalars.endIndex {
        idx = scalars.index(after: idx)
    }
    if idx > scalars.index(after: start) && idx < scalars.endIndex,
        let scalar = UnicodeScalar(scalars[idx].value),
        CharacterSet.lowercaseLetters.contains(scalar) {
        idx = scalars.index(before: idx)
    }
    let transformed = String(scalars[start..<idx]).lowercased() + String(scalars[idx..<scalars.endIndex])
    return transformed
  }



let main = command(
  Argument<String>("module", description: "Your VIPER module name"),
  Option<String>("templates", "./module_templates", description: "Directory with the templates you would like to render"),
  Option<String>("targetDir", "./modules", description: "Directory in which to render your module")

) { (module:String, templates: String, target: String) in
  print("Scaffolding \(module)...")

  let targetPath = Path("\(target)/\(module)")
  let templatePath = Path("\(templates)")
  let templatesPaths = Path.glob("\(templates)/*.stencil")
  try! targetPath.mkpath()

  let ext = Extension()
  ext.registerFilter("lowerFirstWord", filter: lowerFirstWord)
  let environment = Environment(loader: FileSystemLoader(paths: [templatePath]), extensions: [ext])
  let context = ["module": module]

  for template in templatesPaths {
    let fileBaseName: String = template.lastComponentWithoutExtension
    let output = try! environment.renderTemplate(name: "\(fileBaseName).stencil", context: context)
    let targetFileUrl = URL(string: "\(module)\(fileBaseName).swift", relativeTo: targetPath.url)!
    let stringData = output.data(using: .utf8)!
    try! stringData.write(to: targetFileUrl, options: [.atomic])
    print("... wrote \(targetFileUrl)")
  }
  print("Done!")
}

main.run()
