#include "wramp.h"

void displayhexi(int switches){

    //lower right 
    WrampParallel->LowerRightSSD = switches;
    //lower left
    WrampParallel->LowerLeftSSD = (switches >> 4);
    // upper right 
    WrampParallel->UpperRightSSD = (switches >> 8);
    // upper left
    WrampParallel->UpperLeftSSD = (switches >> 12);
    return;

}

void displaydeci(int switches){

    int numdeci = (switches >> 12) * 4096 + (switches >> 8) * 256 + (switches >> 4) * 16 + (switches);
   
    //lower right 
    WrampParallel->LowerRightSSD = (numdeci) %10;
    //lower left
    WrampParallel->LowerLeftSSD = (numdeci /10) %10; 
    // upper right 
    WrampParallel->UpperRightSSD = (numdeci /100) %10  ;
    // upper left
    WrampParallel->UpperLeftSSD = (numdeci /1000);
    return; 
}

void parallel_main(){
    // Variables decalered 
    int switches = 0;
    int base = 16; 
    int Button = 0;

    while(1) {

		//Read current value from parallel switch register
		switches = WrampParallel->Switches;

        //decimal, right  button 
        if (WrampParallel->Buttons != 0 && WrampParallel->Buttons != switches ){
            Button = WrampParallel->Buttons;
        }

        switch (Button)
        {
        case 1:
            displaydeci(switches);
            break;
        
        case 2:
            displayhexi(switches);
            break;
        
        case 4:
            return;
        
        default:
            break;
        }

    }
    displaydeci(switches);
}





