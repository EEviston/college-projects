#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

// 0 if not in state, 1 if in state

int state2 = 0;		//digit state (+/-)
int state3 = 0;		//digit state (8-9)
int state4 = 0;		//digit state (0-7)
int state5 = 0;		//letter state
int state6 = 0;		//hex state
int state7 = 0;		//octal state

int valid = 0;




int scanner(char sequence[])
{
	int i = 0, count = 0;
	char element;
	for(i; sequence[i] != '\0'; i++)
	{
		count++;
	}
	i = 0;
	while(sequence[i] != '\0')
	{
		//element = atoi(sequence[i]);
		switch(element)
		{
			case '+':
			case '-':
				state2 = 1;		// move to state 2

				state3 = 0;
				state4 = 0;
				state5 = 0;
				state6 = 0;
				state7 = 0;		
				break;

			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
				state4 = 1;		//move to state 4

				state2 = 0;		
				state3 = 0;
				state5 = 0;
				state6 = 0;
				state7 = 0;	
				break;	

			case '8':
			case '9':
				state3 = 1;		//move to state 3

				state2 = 0;		
				state4 = 0;
				state5 = 0;
				state6 = 0;
				state7 = 0;	
				break;

			if(state3 == 1)		//hex number has to start with a digit even if 0
			{
				case 'a':
				case 'b':
				case 'c':
				case 'd':
				case 'e':
				case 'f':
				state5 = 1;		//move to state 5

				state2 = 0;		
				state3 = 0;
				state4 = 0;
				state6 = 0;
				state7 = 0;	
				break;		
			}

			// valid octal
			if((state4 == 1) && (i == count))  //if in state 4 (0-7) and the 'b' is last character
			{
				case 'B':
				state7 = 1;		//move to state 7

				state2 = 0;		
				state3 = 0;
				state4 = 0;
				state5 = 0;
				state6 = 0;

				valid = 1;
				return octalNumber(sequence);

				break;
			}

			// valid hexadecimal
			if((state3 == 1) || (state4 == 1) || (state5 == 1) && (i == count)) //if in state 3,4 or 5 and 'h' is last character
			{	
				case 'h':
				state6 = 1;		//move to state 6

				state2 = 0;		
				state3 = 0;
				state4 = 0;
				state5 = 0;
				state7 = 0;

				valid = 1;

				break;
			}

			// vaild decimal
			if((state3 == 1) || (state4 == 1) && i == count && isdigit(element))
			{
				valid = 1;
			}

			default: return;	
		}

		i++;
	}
}



/*
int isValid(char[] sequence)
{
	int i = sequence.length();

	if(sequence[i].isdigit())
	{
		digitNumber(sequence);
		return 1;
	}
	else if(sequence[i] == 'h')
	{
		hexNumber(sequence);
		return 1;
	}
	else if(sequence[i] == 'b')
	{
		octalNumber(sequence);
		return 1;
	}
	else
		return 0;
}

char[] digitNumber(char[] sequence)
{
	return sequence;
}

/*int digitNumber(char[] sequence)		//returning as int using algorithm
{
	int result;
	int multiplier = 0;
	int prevResult = 0;
	for(int i=0; i<sequence.length(); i++)
	{
		result = (multiplier * 10) * sequence[i] + prevResult;
		prevResult = result;
		multiplier *= 10;
	}
	return result;
}
*/
int octalNumber(char* sequence)
{
	int n;
	sscanf(sequence, "%d", &n);
	int decimal = 0, i = 0, rem;
    while (n!=0)
    {
        rem = n%10;
        n/=10;
        decimal += rem*pow(8,i);
        ++i;
    }
    return decimal;
}


/*int isValid(char[] sequence)
{
	int i;
	for(i=0; i<sequence.length(); i++)
	{
		switch(sequence[i])
		{
			case 'a'|'b'|'c'|'d'|'e'|'f':
		} 
	}
}
*/
int main(int argc, char* argv[])
{
	char sequence[10];
	//sequence = malloc(strlen(sequence) + 1 * sizeof(char));
	printf("Enter lexeme sequence: ");
	scanf("%s", sequence);
	int print = scanner(sequence);
	printf("%d\n", print);
	return 0;
}