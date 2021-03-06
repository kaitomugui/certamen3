//
//  ContentView.swift
//  certamen3
//
//  Created by Franco Stefano Ortega Cordero on 14-06-21.
//
import SwiftUI

struct ContentView: View {

    @State private var newNota = ""
    @State private var allNota: [NotaItem] = []
    private let todosKey = "todosKey"

    
    init() { //Perminte cambiar el diseño del BatTitle

        UINavigationBar.appearance().backgroundColor = .systemRed

         UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
                   .font : UIFont(name:"Helvetica Neue", size: 40)!]

    }
    
    var body: some View {
        NavigationView{
            
            VStack{
                ZStack{
                    VStack(spacing: 1.0){
                        HStack{
                            TextField("Agregar Nota", text:$newNota)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action:{
                                guard !self.newNota.isEmpty else {return}
                                self.allNota.append(NotaItem (nota:self.newNota))
                                self.newNota = ""
                                self.saveTodos()
                            })
                            {
                                Image(systemName: "plus.rectangle.fill").padding()
                            }
                        }.padding(.leading, 5)
                        List{
                            ForEach(allNota){ notaItem in
                                Text(notaItem.nota)
                            }.onDelete(perform: { IndexSet in
                                deleteTodos(al: IndexSet)
                            })
                        }
                    }.foregroundColor(Color.red).background(Color.black)
                    .navigationBarTitle(Text("Lista de Notas"))
                }.onAppear(perform: loadTodos)
            }
        }
    }
    
    private func deleteTodos(al offsets: IndexSet){
        self.allNota.remove(atOffsets: offsets )
        saveTodos()
    }
    
    private func loadTodos(){
        if let todosData = UserDefaults.standard.value(forKey: todosKey) as? Data{
            if let todosList = try? PropertyListDecoder().decode(Array<NotaItem>.self, from: todosData) {
                self.allNota = todosList
            }
        }
    }
    
    private func saveTodos(){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allNota), forKey: todosKey)
    }
}
struct NotaItem: Codable, Identifiable {
    let id = UUID()
    let nota: String
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
