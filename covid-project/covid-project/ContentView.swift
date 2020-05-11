//
//  ContentView.swift
//  covid-project
//
//  Created by Wisnu Anggara on 10/05/20.
//  Copyright © 2020 Untitled Company. All rights reserved.
//


import SwiftUI
import Foundation
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit


struct ContentView: View {
    var body: some View {
        
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @State var index = 0
    @State var main : MainData!
    @State var daily : [Daily] = []
    @State var last : Int = 0
    @State var country = "indonesia"
    @State var alert = false
    @State var dark = false
    @State var show = false
    
    var body: some View{
        
        ZStack(alignment: .leading){
            GeometryReader{_ in
                VStack{
                    ZStack{
                        HStack{
                            Button(action: {
                                withAnimation(.default){
                                    self.show.toggle()
                                }
                            }, label: {
                                Image(systemName: "list.dash")
                                    .font(.title)
                            } )
                            Spacer()
                        }
                        Text("Home")
                    }
                    .padding()
                    .foregroundColor(.primary)
                    .overlay(Rectangle().stroke(Color.primary.opacity(0),lineWidth: 1).edgesIgnoringSafeArea(.all))
                    
                    Spacer()
                
                    VStack{
                        
                        if self.main != nil && !self.daily.isEmpty{
                            
                            VStack{
                                
                                VStack(spacing: 18){
                                    
                                    HStack{
                                        
                                        Text("Statistics")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            
                                            self.Dialog()
                                            
                                        }) {
                                            
                                            Text(self.country.uppercased())
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                                
                                            
                                            
                                                
                                            
                                        }
                                        
                                    }.padding(.top,5)
                                    
                                    HStack{
                                        
                                        Button(action: {
                                            
                                            self.index = 0
                                            self.main = nil
                                            self.daily.removeAll()
                                            self.getData()
                                            
                                        }) {
                                            
                                            Text("My Country")
                                                .foregroundColor(self.index == 0 ? .black : .white)
                                                .padding(.vertical, 12)
                                                .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                                        }
                                        .background(self.index == 0 ? Color.white : Color.clear)
                                        .clipShape(Capsule())
                                        
                                        
                                        Button(action: {
                                            
                                            self.index = 1
                                            self.main = nil
                                            self.daily.removeAll()
                                            self.getData()
                                            
                                        }) {
                                            
                                            Text("Global")
                                                .foregroundColor(self.index == 1 ? .black : .white)
                                                .padding(.vertical, 12)
                                                .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                                        }
                                        .background(self.index == 1 ? Color.white : Color.clear)
                                        .clipShape(Capsule())
                                        
                                    }
                                    .background(Color.black.opacity(0.25))
                                    .clipShape(Capsule())
                                    .padding(.top, 10)
                                    
                                    
                                    HStack(spacing: 15){
                                        
                                        VStack(spacing: 12){
                                            
                                            Text("Affected")
                                                .fontWeight(.bold)
                                            
                                            Text("\(self.main.cases)")
                                                .fontWeight(.bold)
                                                .font(.title)
                                            
                                        }
                                        .padding(.vertical)
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                                        .background(Color("affected"))
                                        .cornerRadius(12)
                                        
                                        VStack(spacing: 12){
                                            
                                            Text("Deaths")
                                                .fontWeight(.bold)
                                            
                                            Text("\(self.main.deaths)")
                                                .fontWeight(.bold)
                                                .font(.title)
                                            
                                        }
                                        .padding(.vertical)
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                                        .background(Color("death"))
                                        .cornerRadius(12)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                    
                                    HStack(spacing: 15){
                                        
                                        VStack(spacing: 12){
                                            
                                            Text("Recovered")
                                                .fontWeight(.bold)
                                            
                                            Text("\(self.main.recovered)")
                                                .fontWeight(.bold)
                                            
                                        }
                                        .padding(.vertical)
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                                        .background(Color("recovered"))
                                        .cornerRadius(12)
                                        
                                        VStack(spacing: 12){
                                            
                                            Text("Active")
                                                .fontWeight(.bold)
                                            
                                            Text("\(self.main.active)")
                                                .fontWeight(.bold)
                                            
                                        }
                                        .padding(.vertical)
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                                        .background(Color("active"))
                                        .cornerRadius(12)
                                        
                                        
                                        VStack(spacing: 12){
                                            
                                            Text("Serious")
                                                .fontWeight(.bold)
                                            
                                            Text("\(self.main.critical)")
                                                .fontWeight(.bold)
                                            
                                        }
                                        .padding(.vertical)
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                                        .background(Color("serious"))
                                        .cornerRadius(12)
                                        
                                    }
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                    
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 45)
                                .background(self.dark ? Color.clear : Color("bg"))
                                
                                VStack(spacing: 15){
                                    
                                    HStack{
                                        
                                        Text("Last 7 Days")
                                            .font(.title)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                    .padding(.top)
                                    
                                    HStack{
                                        
                                        ForEach(self.daily){i in
                                            
                                            VStack(spacing: 10){
                                                
                                                Text("\(i.cases / 1000)K")
                                                    .lineLimit(1)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                
                                                GeometryReader{g in
                                                    
                                                    VStack{
                                                        
                                                        Spacer(minLength: 0)
                                                        
                                                        Rectangle()
                                                            .fill(Color("death"))
                                                            .frame(width: 15,height: self.getHeight(value: i.cases, height: g.frame(in: .global).height))
                                                    }
                                                }
                                                
                                                Text(i.day)
                                                    .lineLimit(1)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.bottom, -30)
                                .offset(y: -30)
                            }
                        }
                        else{
                            
                            Indicator()
                        }
                    }
                    .alert(isPresented: self.$alert, content: {
                        
                        Alert(title: Text("Error"), message: Text("Invalid Country Name"), dismissButton: .destructive(Text("Ok")))
                    })
                        .onAppear {
                            
                            self.getData()
                    }
                    
                    
                    
                }
            }
            HStack{
                Menu(dark: self.$dark, show: self.$show)
                    .preferredColorScheme(self.dark ? .dark : .light)
                    .offset(x:self.show ? 0 : -UIScreen.main.bounds.width/1.5)
                
                Spacer(minLength: 0)
            }
            .background(Color.primary.opacity(self.show ? (self.dark ? 0.05 : 0.2) :0).edgesIgnoringSafeArea(.all))
            
        }
        
        
    }
    
    func getData(){
        
        var url = ""
        
        if self.index == 0{
            
            url = "https://corona.lmao.ninja/v2/countries/\(self.country)?yesterday=false"
        }
        else{
            
            url = "https://corona.lmao.ninja/v2/all?today"
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSONDecoder().decode(MainData.self, from: data!)
            
            self.main = json
        }
        .resume()
        
        var url1 = ""
        
        if self.index == 0{
            
            url1 = "https://corona.lmao.ninja/v2/historical/\(self.country)?lastdays=7"
        }
        else{
            
            url1 = "https://corona.lmao.ninja/v2/historical/all?lastdays=7"
        }
        
        let session1 = URLSession(configuration: .default)
        
        session1.dataTask(with: URL(string: url1)!) { (data, _, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            var count = 0
            var cases : [String : Int] = [:]
            
            if self.index == 0{
                
                let json = try! JSONDecoder().decode(MyCountry.self, from: data!)
                cases = json.timeline["cases"]!
            }
            else{
                
                let json = try! JSONDecoder().decode(Global.self, from: data!)
                cases = json.cases
            }
            
            for i in cases{
                
                self.daily.append(Daily(id: count, day: i.key, cases: i.value))
                count += 1
            }
            
            self.daily.sort { (t, t1) -> Bool in
                
                if t.day < t1.day{
                    
                    return true
                }
                else{
                    
                    return false
                }
            }
            
            self.last = self.daily.last!.cases
        }
        .resume()
    }
    
    func getHeight(value : Int,height:CGFloat)->CGFloat{
        
        // safer Side...
        
        if self.last != 0{
            
            let converted = CGFloat(value) / CGFloat(self.last)
            
            return converted * height
        }
        else{
            
            return 0
        }
    }
    
    func Dialog(){
        
        let alert = UIAlertController(title: "Country", message: "Type A Country", preferredStyle: .alert)
        
        alert.addTextField { (_) in
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            
            for i in countryList{
                
                if i.lowercased() == alert.textFields![0].text!.lowercased(){
                    
                    self.country = alert.textFields![0].text!.lowercased()
                    self.main = nil
                    self.daily.removeAll()
                    self.getData()
                    return
                }
            }
            
            self.alert.toggle()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

struct Menu : View {
    @Binding var dark : Bool
    @Binding var show : Bool
    
    var body: some View{
        VStack{
            HStack{
                Button(action: {
                    withAnimation(.default){
                        self.show.toggle()
                    }
                }, label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                    
                })
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title)
                })
            }
            .padding(.top)
            .padding(.bottom, 25)
            
            Image("pic")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            
            VStack(spacing:12){
                Text("Wisnu Anggara")
                Text("Developer")
                    .font(.caption)
            }
            .padding(.top, 25)
            
            HStack(spacing : 22){
                Image(systemName: "moon.fill")
                    .font(.title)
                
                Text("DarkMode")
                
                
                Button(action: {
                    self.dark.toggle()
                    UIApplication.shared.windows.first?.rootViewController?.view
                        .overrideUserInterfaceStyle = self.dark ? .dark : .light
                }, label: {
                    Image("off")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .rotationEffect(.init(degrees: self.dark ? 180 : 0))
                    
                })
            }
            .padding(.top, 25)
            
            Divider()
            
            
            
            
            
            Spacer()
            
            
            
            
        }
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width/1.5)
        .background((self.dark ? Color.black :
            Color.white).edgesIgnoringSafeArea(.all))
            .overlay(Rectangle().stroke(Color.primary.opacity(0.2),lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
        
    }
}



class Host : UIHostingController<ContentView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}


// Data Models For JSON Parsing....

struct Daily: Identifiable{
    
    var id : Int
    var day : String
    var cases : Int
}

struct MainData : Decodable{
    
    var deaths : Int
    var recovered : Int
    var active : Int
    var critical : Int
    var cases : Int
}

struct MyCountry : Decodable {
    
    var timeline : [String : [String : Int]]
}

struct Global : Decodable {
    
    var cases : [String : Int]
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) ->  UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView:  UIActivityIndicatorView, context: Context) {
        
        
    }
}


var countryList = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cabo Verde",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cayman Islands",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Christmas Island",
    "Colombia",
    "Congo",
    "Croatia",
    "Cuba",
    "Curaçao",
    "Cyprus",
    "Czechia",
    "Côte d'Ivoire",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Eswatini",
    "Ethiopia",
    "Falkland Islands",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "French Guiana",
    "French Polynesia",
    "Gabon",
    "Gambia (the)",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guadeloupe",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Heard Island and McDonald Islands",
    "Holy See",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea",
    "Korea",
    "Kuwait",
    "Kyrgyzstan",
    "Lao People's Democratic Republic",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macao",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Martinique",
    "Mauritania",
    "Mauritius",
    "Mayotte",
    "Mexico",
    "Micronesia",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger (the)",
    "Nigeria",
    "Niue",
    "Norfolk Island",
    "Northern Mariana Islands",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Palestine, State of",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Pitcairn",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Republic of North Macedonia",
    "Romania",
    "Russian Federation",
    "Rwanda",
    "Réunion",
    "Saint Barthélemy",
    "Saint Helena, Ascension and Tristan da Cunha",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Martin (French part)",
    "Saint Pierre and Miquelon",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Sint Maarten",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Georgia and the South Sandwich Islands",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Suriname",
    "Svalbard and Jan Mayen",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
    "Taiwan",
    "Tajikistan",
    "Tanzania, United Republic of",
    "Thailand",
    "Timor-Leste",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks and Caicos Islands (the)",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "UAE",
    "UK",
    "USA",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Venezuela",
    "Viet Nam",
    "Wallis and Futuna",
    "Western Sahara",
    "Yemen",
    "Zambia",
    "Zimbabwe",
    "Åland Islands"
]


