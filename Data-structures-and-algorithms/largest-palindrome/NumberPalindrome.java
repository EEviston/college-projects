/**
 * CS2010 (Hilary Term) - Assignment 2
 * 
 * Largest Palindrome as product of N-Digit numbers
 * 
 * A palindromic number reads the same both ways. The largest palindromic number made 
 * from the product of two 2-digit numbers is 9009 = 91 × 99.
 * 
 * Problem: Develop an algorithm, which will be able to calculate the largest palindromic number,
 * which is a product of two n-digit numbers. In order to achieve important optimisations, you can
 * assume that n is odd. 
 * 
 * 1) Implement reverse method. This method takes in an integer and returns its reverse representation
 * 	  reverse(12345) = 54321. You shouldn't convert the number into string and use String APIs.
 *  
 * 2) Implement the isPalindrome method.
 * 
 * 3) Look at the naive implementation of largestPalindromeThreeDigitNumberProduct method.
 * 	  This method calculates the largest palindrome number, which is a product of 3 digit numbers.
 * 
 * 4) Once you understand the largestPalindromeThreeDigitNumberProduct method, think of how you could
 * 	  generalise this approach so that it works for products of different number sizes.
 * 	  largestPalindromeNDigitProduct(3) should return largest palindrome which is a product of two, 3 digit numbers
 * 	  largestPalindromeNDigitProduct(5) should return largest palindrome which is a product of two, 5 digit numbers
 * 
 * 5) Optimise the method so that it runs in reasonable amount of time (~1s-2s) even for products of 7 digit numbers
 * 
 * 6) Test your code by providing additional tests in the NumberPalindromeTest class.
 * 
 * @author:
 * 
 */

import java.lang.Math;

public class NumberPalindrome 
{
	
	/**
	 * Method which takes in a number and returns its reverse. E.g. reverse(12345) = 54321
	 * 
	 * @param n - number to be reversed
	 * @return the reversed number n
	 */
	public static long reverse(long n)
	{
		long result = 0;
	    long rem = 0;
	    
	    while (n > 0) 
	    {
	        rem = n % 10;
	        n = n / 10;
	        result = result * 10 + rem;
	    }
	    
	    return result;
		
	}
	
	/**
	 * Method to check if a number is palindromic. E.g. isPalindrome(123) = false, isPalindrome(101) = true
	 * 
	 * @param n - number to check
	 * @return boolean value representing whether n is a palindrome
	 */
	public static boolean isPalindrome(long n) 
	{
		boolean result = false;
		
		if(reverse(n) == n)
		{
			result = true;
		}
		
		return result;
	}
	
	/**
	 * Naive implementation of the method returning the largest palindrome, which is a product of
	 * two 3-digit numbers.
	 * 
	 * @return largest palindrome
	 */
	public static int largestPalindromeThreeDigitNumberProduct() 
	{
		int max_prod = Integer.MIN_VALUE;
		for (int i = 999; i > 99; i--)
		{
			int j = 999;
			while (j >= i) 
			{
				int prod = i * j;

				if (isPalindrome(prod)) 
				{
					max_prod = Math.max(prod, max_prod);
				}
				j = j - 1;
			}
		}
		return max_prod;

	}
	
	/**
	 * Method, which takes in a number of digits. It then calculates the largest palindrome, which is
	 * a product of two numbers made up of that many digits.
	 * 
	 * In order to optimise the calculation, you can assume the digits is an odd number.
	 * 
	 * @param digits 
	 * @return largest palindrome which a product of two numbers having specified number of digits.
	 */
	public static long largestPalindromeNDigitProduct(int digits) 
	{
		long number = 9;	
		
		for(int i = 1; i < digits; i++)
		{
			number *= 10;
			number += 9;
		}
		
		//System.out.println("" + number);	
		long prod = 0;
		
		for(long i = number; i > number/10; i-=2)
		{
			long j = number;
			
			while(j >= i)
			{
				prod = i * j;
				
				if(isPalindrome(prod))
				{
					//System.out.println("" + prod);
					return prod;
				}
				j--;
			}
		}	
		return 0;
	}
	
	
	/*public static long largestPalindromeNDigitProduct(int digits)
	{
		int max_prod = Integer.MIN_VALUE;
		
		int number = (int) Math.pow(10, (digits - 1));
		
		for(int i = number; i > number/10; i--)
		{
			int j = number;
			while(j >= i)
			{
				int prod = i * j;
				
				if(isPalindrome(prod))
				{
					max_prod = Math.max(prod, max_prod);
				}
				j--;
			}
		}
		System.out.println(max_prod);
		return max_prod;
	}
	*/
	
}