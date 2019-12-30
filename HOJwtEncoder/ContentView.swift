//
//  ContentView.swift
//  HOJwtEncoder
//
//  Created by Daniel Gunawan on 20/12/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import SwiftUI
import SwiftJWT

struct ContentView: View {
    @State var issuerIdText = ""
    @State var keyIdText = ""
    @State var privateKeyPath: URL?
    @State var signedJWTToken = ""
    
    @State private var isShowAlert = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Lets Encode !")
                .font(.title)
            
            Form {
                Section(header: Text("Input")) {
                    TextField("Issuer Id", text: self.$issuerIdText)
                    TextField("Key Id", text: self.$keyIdText)
                    
                    
                    HStack {
                        Button(action: {
                            let panel = NSOpenPanel()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                let result = panel.runModal()
                                if result == .OK {
                                    self.privateKeyPath = panel.url
                                }
                            }
                        }) {
                            Text("Select file")
                        }
                        .foregroundColor(.black)
                        .background(Color.gray)
                        .cornerRadius(4.0)
                        .padding(.top)
                        
                        Text(privateKeyPath?.absoluteString ?? "")
                            .font(.footnote)
                    }
                    
                    Button(action: getEncoded) {
                        Text("Encode")
                    }
                    .background(Color.blue)
                    .cornerRadius(4.0)
                    .padding(.all)
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(minWidth: 500, minHeight: 400)
        .alert(isPresented: self.$isShowAlert) { () -> Alert in
            Alert(
                title: Text("JWT Token"),
                message: Text(self.signedJWTToken),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
    
    func getEncoded() {
        guard let privateKeyPath = self.privateKeyPath,
            let privateKey = try? Data.init(contentsOf: privateKeyPath, options: .alwaysMapped)
            else {return}
        
        let jwtHeader = Header(typ: "JWT", kid: keyIdText)
        let jwtPayload = AppStoreConnectPayload(iss: issuerIdText, exp: Date().addingTimeInterval(TimeInterval(20 * 60)))
        
        var myJWT = JWT(header: jwtHeader, claims: jwtPayload)
        let jwtSigner = JWTSigner.es256(privateKey: privateKey)
        
        guard let signedJWT = try? myJWT.sign(using: jwtSigner) else {return}
        self.signedJWTToken = signedJWT
        self.isShowAlert = true
        
    }
    
    struct AppStoreConnectPayload: Claims {
        let iss: String?
        let exp: Date?
        let aud: String = "appstoreconnect-v1"
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
