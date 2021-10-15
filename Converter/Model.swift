//
//  Model.swift
//  Converter
//
//  Created by Илья Викторов on 22.09.2021.
//

import UIKit

class Currency {
    
    var NumCode: String?
    var CharCode: String?
    var Nominal: String?
    var nominalD: Double?
    var Name: String?
    var Value: String?
    var valueD: Double?
    
    static func rouble() -> Currency {
        
        let rub = Currency()
        
        rub.CharCode = "RUR"
        rub.Name = "Российский рубль"
        rub.Nominal = "1"
        rub.nominalD = 1
        rub.Value = "1"
        rub.valueD = 1
        
        return rub
    }
}

class Model: NSObject {
    
    static let shared = Model()
    
    var currentDate: String = ""
    
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
    func convert(amount: Double?) -> String {
        
        if amount == nil{
            return ""
        }
    
        let d = (fromCurrency.nominalD! * fromCurrency.valueD!) / (toCurrency.nominalD! * toCurrency.valueD!) * amount!
        
        return String(d)
    }
    
    var currencies: [Currency] = []
    var currentCurrency : Currency?
    
    var currentCharacters: String = ""
    
    var pathForXML: String{
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/data.xml"
        
        if FileManager.default.fileExists(atPath: path){
            return path
        }
        
        return Bundle.main.path(forResource: "data", ofType: "xml")!
        
    }
    var urlForXML: URL{
        return URL(fileURLWithPath: pathForXML)
    }
    
    //Фукнция загрузки XML файла и сохранение его данных
    //http://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002
    func loadXMLFile(date: Date?){
        
        var strUrl = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        if date != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            strUrl = strUrl + dateFormatter.string(from: date!)
        }
        
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { data, responce, error in
            
            var errorGlobal: String?
            
            if error == nil{
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/data.xml"
                print(path.description)
                
                let urlForSave = URL(fileURLWithPath: path)
                
                do{
                    try data?.write(to: urlForSave)
                    print("Файл загружен")
                    self.parseXML()
                }catch{
                    print("Error when save data: \(error.localizedDescription)")
                    errorGlobal = error.localizedDescription

                }
                
            }else{
                print("Error when loadXMLFile: \(String(describing: error?.localizedDescription))")
                errorGlobal = error?.localizedDescription
            }
            
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ErrorWhenXMLloading"), object: self, userInfo: ["ErrorName":errorGlobal])
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("startLoadingXML"), object: self)
        task.resume()
        
    }
    
    func parseXML() {
        
        currencies = [Currency.rouble()]
        
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        
        print("Данные обновлены")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
    }
    
    
}

extension Model: XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
        
        if elementName == "ValCurs"{
            
            if let currentDateString = attributeDict["Date"] {
                
                currentDate = currentDateString
            }
        }
        
        if elementName == "Valute"{
            currentCurrency = Currency()
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
        switch elementName {
        
        case "NumCode":
            currentCurrency?.NumCode = currentCharacters
        case "CharCode":
            currentCurrency?.CharCode = currentCharacters
        case "Nominal":
            currentCurrency?.Nominal = currentCharacters
            currentCurrency?.nominalD = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        case "Name":
            currentCurrency?.Name = currentCharacters
        case "Value":
            currentCurrency?.Value = currentCharacters
            currentCurrency?.valueD = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        case "Valute":
            currencies.append(currentCurrency!)
            
        default:
            break
        }
        
    }
    
    
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String){
        
        currentCharacters = string
    }
}
