import SwiftUI
import SimpleSwiftCrypto

struct ContentView: View {
    // Pola tekstowe
    @State private var userInput: String = ""             //  Pole 1: Wprowadzane zdania przez użytkownika
    @State private var encryptedMessage: String = ""      // Pole 2: Zaszyfrowana wiadomość
    @State private var encryptedInput: String = ""        // Pole 3: Wklejona zaszyfrowana wiadomość
    @State private var decryptedMessage: String = ""      // Pole 4: Odszyfrowane zdanie
    
    // Hasło do szyfrowania/deszyfrowania
    private let password: String = "superbezpiecznyklucz"
    
    var body: some View {
        VStack(spacing: 20) {
            // Pole 1: Tekst wprowadzany przez użytkownika
            TextField("Wprowadź zdanie do zaszyfrowania", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Przycisk szyfrowania
            Button("Szyfruj") {
                do {
                    // Szyfrowanie wiadomości
                    encryptedMessage = try SimpleCrypto.encrypt(message: userInput, password: password)
                } catch {
                    encryptedMessage = "Błąd szyfrowania: \(error)"
                }
            }
            .buttonStyle(.borderedProminent)
            
            // Pole 2: Zaszyfrowana wiadomość
            TextField("Zaszyfrowana wiadomość", text: $encryptedMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(true) // Tylko do odczytu
            
            // Pole 3: Wprowadzenie zaszyfrowanej wiadomości
            TextField("Wklej zaszyfrowaną wiadomość", text: $encryptedInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Przycisk deszyfrowania
            Button("Deszyfruj") {
                do {
                    // Deszyfrowanie wiadomości
                    decryptedMessage = try SimpleCrypto.decrypt(message: encryptedInput, password: password)
                } catch {
                    decryptedMessage = "Błąd deszyfrowania: \(error)"
                }
            }
            .buttonStyle(.borderedProminent)
            
            // Pole 4: Odszyfrowane zdanie
            TextField("Odszyfrowana wiadomość", text: $decryptedMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(true) // Tylko do odczytu
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
