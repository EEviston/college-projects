import java.util.ArrayList;
import java.util.List;

/**
 * CS2010 (Hilary Term) - Assignment 3
 * 
 * Self Divisible Numbers
 * 
 * Self divisible numbers are those, that satisfy the following property:
 * 		a) All the 9 digits in the number are different, i.e. each of the 9 digits 1..9 is used once.
 * 		b) The number denoted by the first k-digits is divisible by k (i.e. the first k-digits are a multiple of k)
 *  
 *  	Consider the number 723654981; 
 *  	We have:   1|7,  2|72, 3|723, 4|7236, 5|72365, 6|723654  [read  a|b  as â€œa divides bâ€ or â€œb is a multiple of aâ€ ] 
 *  	but 7 does not divide  7236549. So this number does not satisfy property b).
 *  
 * Create a Java program that generates all 9-digit numbers.
 * 
 * 1) Implement all methods described bellow - like in HT assignment 1, calculate the values in the constructor
 * 2) Implement tests, which sufficiently cover your code
 *  
 * @author:
 * 
 */

public class SelfDivisibleNumbers 
{
	List<Integer> selfDivisibleNumbers = new ArrayList<Integer>();
	
	int[] der;
	boolean[] used;

	public SelfDivisibleNumbers() 
	{
		der = new int[9];
		used = new boolean[9];
		all_ders(0);
		System.out.println(selfDivisibleNumbers.get(0));
	}
	
	/**
	 * Method to produce a number corresponding to first k digits of the digits array
	 * @param digits
	 * @param k number of digits to construct the result from
	 * @return number
	 */
	public static int getFirstKDigitNumber(int[] digits, int k) 
	{
		int number = 0;

		for(int i = 0; i < k; i++)
		{
			number *= 10;
			number += digits[i];
		}
		return number;
	}
	
	/**
	 * Method to check if the specified number is divisible by the divisor
	 * @param number
	 * @param divisor
	 * @return true if number is divisible by the divisor
	 */
	public boolean isDivisible(int number, int divisor) 
	{
		if((number % divisor) == 0)		
			return true;
		else
		return false;
	}
	
	/**
	 * Method to return a list containing all self divisible numbers found
	 * @return 9-digit self divisible numbers
	 */
	public List<Integer> getSelfDivisibleNumbers() 
	{
		return selfDivisibleNumbers;
	}
	
	/**
	 * Method to return the number of self divisible numbers found
	 * @return number of 9-digit self divisible numbers
	 */
	public int getNumberOfSelfDivisibleNumbers() 
	{
		return selfDivisibleNumbers.size();
	}
	
	void all_ders(int k)
    {
		int count = 0;
        if (k == 9)
        {
        	for(int i = 1; i <= der.length; i++)
        	{
        		if(isDivisible(getFirstKDigitNumber(der, i), i))
        		{
        			count++;
        		}
        	}
        	if(count == 9)
        	{
        		selfDivisibleNumbers.add(getFirstKDigitNumber(der,9));
        	}
        	
        }
            
        else
            for (int j = 0; j < der.length; j = j+1)
                if (!used[j])
                {
                    der[k] = j+1;
                    used[j] = true;
                    all_ders(k+1);
                    used[j] = false;
                }
    }

	
	
	
	
	
	
}