import Stencil
import Foundation
import PathKit
import Commander

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

  let environment = Environment(loader: FileSystemLoader(paths: [templatePath]))
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
