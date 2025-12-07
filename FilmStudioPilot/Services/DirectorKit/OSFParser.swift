//
//  OSFParser.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

/// Parser for Open Screenplay Format (OSF) XML
/// Reference: https://github.com/OpenScreenplayFormat/osf-sdk
class OSFParser {
    
    /// Parse OSF XML into Screenplay model
    func parseOSF(_ xmlString: String) throws -> Screenplay {
        // For v1, we'll do basic XML parsing
        // In production, use XMLParser or a proper XML library
        
        guard let xmlData = xmlString.data(using: .utf8) else {
            throw OSFParseError.invalidEncoding
        }
        
        let parser = XMLParser(data: xmlData)
        let delegate = OSFXMLParserDelegate()
        parser.delegate = delegate
        
        guard parser.parse() else {
            throw OSFParseError.parseFailed(delegate.parseError?.localizedDescription ?? "Unknown error")
        }
        
        return delegate.screenplay
    }
    
    /// Convert Screenplay to OSF XML
    func generateOSF(from screenplay: Screenplay) -> String {
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        xml += "<osf version=\"1.0\">\n"
        xml += "  <title>\(escapeXML(screenplay.title))</title>\n"
        
        if let metadata = screenplay.metadata {
            xml += "  <metadata>\n"
            if let author = metadata.author {
                xml += "    <author>\(escapeXML(author))</author>\n"
            }
            if let version = metadata.version {
                xml += "    <version>\(escapeXML(version))</version>\n"
            }
            xml += "  </metadata>\n"
        }
        
        xml += "  <scenes>\n"
        for scene in screenplay.scenes {
            xml += generateSceneXML(scene)
        }
        xml += "  </scenes>\n"
        
        xml += "</osf>"
        return xml
    }
    
    private func generateSceneXML(_ scene: ScreenplayScene) -> String {
        var xml = "    <scene number=\"\(scene.sceneNumber)\">\n"
        
        // Scene heading
        xml += "      <heading>\n"
        xml += "        <location>\(escapeXML(scene.heading.location))</location>\n"
        xml += "        <time>\(escapeXML(scene.heading.timeOfDay))</time>\n"
        xml += "        <interior-exterior>\(scene.heading.interiorExterior.rawValue)</interior-exterior>\n"
        xml += "      </heading>\n"
        
        // Action lines
        for action in scene.action {
            xml += "      <action>\(escapeXML(action.text))</action>\n"
        }
        
        // Dialogue
        for dialogue in scene.dialogue {
            xml += "      <dialogue>\n"
            xml += "        <character>\(escapeXML(dialogue.character))</character>\n"
            if let parenthetical = dialogue.parenthetical {
                xml += "        <parenthetical>\(escapeXML(parenthetical))</parenthetical>\n"
            }
            xml += "        <text>\(escapeXML(dialogue.dialogue))</text>\n"
            xml += "      </dialogue>\n"
        }
        
        xml += "    </scene>\n"
        return xml
    }
    
    private func escapeXML(_ string: String) -> String {
        return string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&apos;")
    }
}

class OSFXMLParserDelegate: NSObject, XMLParserDelegate {
    var screenplay: Screenplay!
    var currentScene: ScreenplayScene?
    var currentDialogue: DialogueBlock?
    var currentElement: String = ""
    var parseError: Error?
    
    private var title: String = ""
    private var scenes: [ScreenplayScene] = []
    private var currentSceneNumber: Int = 0
    private var currentHeading: SceneHeading?
    private var currentAction: [ActionLine] = []
    private var currentSceneDialogue: [DialogueBlock] = []
    
    func parserDidStartDocument(_ parser: XMLParser) {
        scenes = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        switch elementName {
        case "scene":
            if let numberStr = attributeDict["number"], let number = Int(numberStr) {
                currentSceneNumber = number
                currentAction = []
                currentSceneDialogue = []
            }
        case "heading":
            currentHeading = SceneHeading(location: "", timeOfDay: "DAY", interiorExterior: .interior)
        case "dialogue":
            currentDialogue = DialogueBlock(character: "", dialogue: "")
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        switch currentElement {
        case "title":
            title += trimmed
        case "location":
            currentHeading?.location += trimmed
        case "time":
            currentHeading?.timeOfDay = trimmed
        case "interior-exterior":
            if trimmed == "EXT" {
                currentHeading?.interiorExterior = .exterior
            }
        case "action":
            currentAction.append(ActionLine(text: trimmed))
        case "character":
            currentDialogue?.character += trimmed
        case "text":
            currentDialogue?.dialogue += trimmed
        case "parenthetical":
            currentDialogue?.parenthetical = trimmed
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "scene":
            if let heading = currentHeading {
                let scene = ScreenplayScene(
                    sceneNumber: currentSceneNumber,
                    heading: heading,
                    action: currentAction,
                    dialogue: currentSceneDialogue
                )
                scenes.append(scene)
            }
            currentHeading = nil
            currentAction = []
            currentSceneDialogue = []
        case "dialogue":
            if let dialogue = currentDialogue {
                currentSceneDialogue.append(dialogue)
            }
            currentDialogue = nil
        default:
            break
        }
        
        currentElement = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        screenplay = Screenplay(
            title: title.isEmpty ? "Untitled" : title,
            osfXML: nil, // Will be regenerated if needed
            scenes: scenes
        )
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseError = parseError
    }
}

enum OSFParseError: Error {
    case invalidEncoding
    case parseFailed(String)
}

