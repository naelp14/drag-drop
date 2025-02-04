//
//  Tree.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 03/02/25.
//

import SwiftUI

struct TestView: View {
 
    let sideChains: [Chain] = [
        Chain(atom: "C", child: []),
        Chain(atom: "C", child: ["H"]),
        Chain(atom: "C", child: ["OH", "OH"])
    ]
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(sideChains, id: \.self) { chain in
                if chain != sideChains.first {
                    Text("-")
                }
                VStack {
                    Text(chain.child.first ?? " ")
                        .frame(height: 30)
                    
                    Text(chain.child.isEmpty ? " " : "|")
                        .frame(height: 10)
                    
                    Text(chain.atom)
                        .frame(height: 30)
                    
                    Text(chain.child.count > 1 ? "|" : " ")
                        .frame(height: 10)
                    
                    Text(chain.child.count > 1 ? chain.child.last! : " ")
                        .frame(height: 30)
                }
            }
        }
        .frame(height: 180)
    }
}

#Preview {
    TestView()
}
