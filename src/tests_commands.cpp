#include <iostream>

using namespace std;

int main() {

    char cmd;

    // Read from the file (or manual input)
    while(cin >> cmd && cmd != 'q') {
        switch (cmd) {

            // Invalid Command
            default:
                cout << "Error 002:" << endl;
                cout << "An invalid command has been entered." << endl;
                cout << "Program will continue..." << endl;

        }

    }

    // Invalid test case due to read fail.
    if(!cin && !cin.eof()) {

        cout << "Error 001:" << endl;
        cout << "A read failed! Invalid test case." << endl;
        return -1;

    }

    return 0;

}