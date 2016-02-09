import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.BeforeClass;
import org.junit.Test;


public class SelfDivisibleNumbersTest 
{

	static SelfDivisibleNumbers sdn;
	
	@BeforeClass
	public static void oneTimeSetUp() throws Exception 
	{
		sdn = new SelfDivisibleNumbers();
	}
	
	@Test
	public void constructorTest() 
	{
		List<Integer> answer = new ArrayList<Integer>();
		answer.add(381654729);
		
		assertNotNull("Checking the constructor",sdn);
		assertEquals("Checking list size", 1, sdn.getNumberOfSelfDivisibleNumbers());
		assertEquals("Checking list size", 1, sdn.selfDivisibleNumbers.size());
		assertEquals("Checking number", answer, sdn.getSelfDivisibleNumbers());
	}

	
	
	
}