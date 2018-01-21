#include <iostream>
int main()
{
	std::cout << " \n";
	std::cout << "RC Airfoil Scaling and Modification Code\n";
	std::cout << "Written by: Niel Lewis\n";
	std::cout << "Date written:6/25/2014\n";
	std::cout << "" << std::endl;
	

	//***BREAK OUT INTO SEPERATE FUNCTION FOR NOW***
//-----------------------------Tutorial-----------------------------------
//In the future once a GUI is added to this code it will not be nessasary to say yes or no everytime
//Instead there will be a button to click on that will open a PDF or something that will direct to the
//Help files.

	int YN;
	int Y = 1;
	int N = 0;
	
	std::cout << "Is this your first time using this code (Y/N)" << std::endl;
	std::cin >> YN;

	if (YN == Y)
		std::cout << " \n";
		std::cout << "-------------------------------------------------\n";
		std::cout << "Introduction: This Code takes inputed airfoil data points from\n";
		std::cout << "a .dat file and modifies them to include cutouts for items\n";
		std::cout << "such as stringers, flanges and webs.\n";
		std::cout << "\n";
		std::cout << "All that is required to operate this code are the following\n";
		std::cout << "known variables.\n";
		std::cout << "   1. Airfoil data\n";
		std::cout << "   2. Wing Span\n";
		std::cout << "   3. Root Chord\n";
		std::cout << "   4. Tip Chord\n";
		std::cout << "   5. Approximate Airfoil Spacing\n";
		std::cout << "   6. Width of Fuselage\n";
		std::cout << "   7. Size of the I beam components\n";
		std::cout << "   8. Size of the Stringers\n";
		std::cout << "   9. Length of Trailing Edge wrap\n";
		std::cout << "  10. Thickness of leading edge wrap\n";
		std::cout << "\n";
		std::cout << "Read the Help section in the code for help in setting up the\n";
		std::cout << "airfoil data, so that you do not experience any errors.\n";
		std::cout << "\n";
		std::cout << "The Root Chord is the chord length at the fuselage, and the\n";
		std::cout << "Tip Chord is the length at the wing tip. This enables the user\n";
		std::cout << "To scale airfoils without having to do it all manually in CAD.\n";
		std::cout << "\n";
		std::cout << "       IF YOU DO NOT KNOW WHAT SORT OF SIZES YOU REQUIRE\n";
		std::cout << "       FOR THE DIFFERENT STRUCTURAL COMPONENTS PLEASE SEE\n";
		std::cout << "       THE STRUCTURES SECTION OF\n";
		std::cout << "            \"NIELs MOTHER OF ALL DBF GUIDE BOOKS\"\n";
		std::cout << "--------------------------------------------------------------\n";
		


//-----------------------User Inputs-------------------------------------
 std::cout << "\n";
 std::cout<<"------------Airfoil & Geometry Inputs--------------"
 int A1 = 




	system ("pause");
	return 0;
}

