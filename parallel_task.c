#include "wramp.h"

void display(int switches, int base){
    //lower right 
    WrampParallel->LowerRightSSD = switches;
    //lower left
    WrampParallel->LowerLeftSSD = switches - base;
    // upper right 
    //WrampParallel->UpperRightSSD = switches % base;
    // upper left
    //WrampParallel->UpperLeftSSD = switches % base;

}

void main(){
    // Variables decalered 
    int switches = 0;
    int base = 16; 

    while(1) {

		//Read current value from parallel switch register
		switches = WrampParallel->Switches;

        //writes it to the ssd
        display(switches, base);
    }
}



