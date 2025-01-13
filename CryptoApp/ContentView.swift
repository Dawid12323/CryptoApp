import SwiftUI
import SimpleSwiftCrypto

struct ContentView: View {
    // Pola tekstowe
    @State private var userInput: String = ""             // Pole 1: Wprowadzane zdania przez użytkownika
    @State private var encryptedMessage: String = ""      // Pole 2: Zaszyfrowana wiadomość (Base64)
    @State private var encryptedInput: String = ""        // Pole 3: Wklejona zaszyfrowana wiadomość (Base64)
    @State private var decryptedMessage: String = ""      // Pole 4: Odszyfrowane zdanie
    
    // Klucz AES
    private let aesKey: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
    
    var body: some View {
        VStack(spacing: 20) {
            // Pole 1: Tekst wprowadzany przez użytkownika
            TextField("Wprowadź zdanie do zaszyfrowania", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Przycisk szyfrowania
            Button("Szyfruj") {
                do {
                    guard let data = userInput.data(using: .utf8) else {
                        encryptedMessage = "Błąd: Nie można skonwertować tekstu na dane."
                        return
                    }
                    if let encryptedData = aesKey.encrypt(data: data) {
                        encryptedMessage = encryptedData.base64EncodedString()
                    } else {
                        encryptedMessage = "Błąd szyfrowania: Nie udało się zaszyfrować danych."
                    }
                } catch {
                    encryptedMessage = "Błąd szyfrowania: \(error.localizedDescription)"
                }
            }
            .buttonStyle(.borderedProminent)
            
            // Pole 2: Zaszyfrowana wiadomość
            TextField("Zaszyfrowana wiadomość (Base64)", text: $encryptedMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(true) // Tylko do odczytu
            
            // Przycisk kopiowania dla pola 2
            Button("Skopiuj Zaszyfrowaną Wiadomość") {
                copyToClipboard(text: encryptedMessage)
            }
            .buttonStyle(.bordered)
            
            // Pole 3: Wprowadzenie zaszyfrowanej wiadomości
            TextField("Wklej zaszyfrowaną wiadomość (Base64)", text: $encryptedInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Przycisk deszyfrowania
            Button("Deszyfruj") {
                do {
                    guard let encryptedData = Data(base64Encoded: encryptedInput) else {
                        decryptedMessage = "Błąd: Nieprawidłowy format Base64."
                        return
                    }
                    if let decryptedData = aesKey.decrypt(data: encryptedData) {
                        decryptedMessage = String(data: decryptedData, encoding: .utf8) ?? "Błąd: Nie można zdekodować danych na tekst."
                    } else {
                        decryptedMessage = "Błąd deszyfrowania: Nie udało się odszyfrować danych."
                    }
                } catch {
                    decryptedMessage = "Błąd deszyfrowania: \(error.localizedDescription)"
                }
            }
            .buttonStyle(.borderedProminent)
            
            // Pole 4: Odszyfrowane zdanie
            TextField("Odszyfrowana wiadomość", text: $decryptedMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(true) // Tylko do odczytu
            
            // Przycisk kopiowania dla pola 4
            Button("Skopiuj Odszyfrowaną Wiadomość") {
                copyToClipboard(text: decryptedMessage)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    // Czyszczenie wszystkich pól
                    userInput = ""
                    encryptedMessage = ""
                    encryptedInput = ""
                    decryptedMessage = ""
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    // Funkcja do kopiowania tekstu do schowka
    private func copyToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
