#include <iostream>
using namespace std;

int main() {
    int righe;
    int colonne;
    char c;
    int i_righe = 1; // Contatore righe
    int i_colonne = 1; // Contatore colonne

    cout << "\nInserisci quante righe vuoi: "<<endl;
    cin >> righe;
    cout << "Inserisci quante colonne vuoi: "<<endl;
    cin >> colonne;
    cout << "Inserisci il carattere che riempira' il rettangolo: "<<endl;
    cin >> c;
    cout << "\n";

    while(i_righe <= righe) {
        while(i_colonne <= colonne) {
            if(i_righe == 1 || i_righe == righe) {
                // Se fa parte della prima o dell'ultima riga allora stampo "*"
                cout << "*";
                i_colonne=(i_colonne+1);
            }
            else if(i_colonne == 1 || i_colonne == colonne) {
                // Se fa parte della prima o dell'ultima colonna allora stampo "*"
                cout << "*";
                i_colonne=(i_colonne+1);
            }
            else {
                cout << c;
                i_colonne=(i_colonne+1);
            }
        }
        cout << "\n";
        i_colonne = 1; // Resetto il contatore delle colonne
        i_righe=(i_righe+1);
    }

    return 0;
}
