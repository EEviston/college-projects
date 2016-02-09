/*****************************************************************************
 * CountiesMap
 *
 * @version 1.0
 * @author TODO
 *
 * The constructor of this class loads a MapImage object.
 * The constructor then computes the regions with the same colour on the map.
 * We call these regions <b>counties</b>.
 * 
 * Once the counties have been computed, their size can be obtained by calling
 * the method <code>getCountySize</code>.
 *
 * 
 * My program is based on the Union Find API. (some credit to Princeton University)
 * This API encapsulates some functions required such as 'void Union' and 'int Find'.
 * The implementations of this API that I utilize in my program are weighted quick-union with path
 * compression.
 * This involves setting the id[] of each examined node to point to the root right after examining 'p'.
 * This means that our 'find' method will have a side effect of compressing the overall tree which is
 * beneficial to us as it keeps the tree almost flat.
 * 
 * N + M(log)N = amortized time for WQUPC.
 * 
 * Amortized running time: N is the amount of pixels and M is the amount of times the getCountySize function is called.
 * Union find is used 'N' times and each union find takes up to ln(N). The run time of the constructor therefore is 
 * O(N + N*lg(N)). getCountySize has a cost of lg(N) (worst-case) and is invoked 'M' times.
 * Total cost of the program is therefore O(N + N*lg(N) + M*lg(N))
 * 
 * Memory usage: N
 *
 *****************************************************************************/
public class CountiesMap
{
  private final MapImage map;
  private final int IMAGE_WIDTH = 2810;
  private final int IMAGE_HEIGTH = 3600;

  // TODO: you may need to add more fields here.

  UnionFind uf = new UnionFind(IMAGE_WIDTH * IMAGE_HEIGTH);				// create instance of my UnionFind class
  
  /**
   * The constructor does all the map calculations.
   * The parameter of the class contains a map of counties of a country.
   * There is no text on the map. It has only single-colour regions.
   * Some of these single-colour regions represent counties (you don't know which ones).
   * There might be other regions on the map such as lakes, oceans, islands etc.
   * 
   * 
   *
   * @param map this is a MapImage object
   */
  public CountiesMap(MapImage map)
  {
     this.map = map;                        
    
     for (int x = map.getMinX(); x < map.getWidth()-1;x++)		// scan through all pixels 
     {
     	for (int y = map.getMinY(); y < map.getHeight()-1;y++)
     	{
     		if(map.getRGB(x, y) != -1)						// neglect white pixels for better efficiency
     		{
    
     			if (map.getRGB(x, y) == map.getRGB(x+1, y))			// check current pixel with next pixel
     			{
     				uf.union(getIndex(x,y), getIndex(x+1,y));
     			}
     			if (map.getRGB(x, y) == map.getRGB(x, y+1))
     			{
     				uf.union(getIndex(x,y), getIndex(x,y+1));		// get indexes and unite
     			}
     		}
     	}
     }
  }

  /**
   * This method returns the size in pixels of the region which includes the point (x,y).
   *
   * @param x the x-coordinate of the point in the region.
   * @param y the y-coordinate of the point in the region.
   * @return the size of the region in pixels.
   */
  public int getCountySize(int x, int y)
  {
    //uf.find(getIndex(x,y));
	int index = getIndex(x,y);					// convert counties' size to one dimensional value (index) and call returnSize in
												//	my UnionFind class
	//return uf.returnSize(index);
    //return 0;
	
	return uf.getSize()[uf.find(getIndex(x,y))];
  }

  /**
   * This method can be used to convert the map's (x,y) coordinates to a unique linear index.
   * Suppose we want to store all pixels of the map in a one-dimensional array.
   * Then the array will have to have size (map.getHeight() * map.getWidth()).
   * Pixel (x,y) will be at position getIndex(x,y) in the array.
   *
   * @param x the x-coordinate of the pixel.
   * @param y the y-coordinate of the pixel.
   * @return the index in a 1-dimensional array corresponding to pixel (x,y).
   */
  private int getIndex(int x, int y)
  {
    return y * map.getWidth()  +  x;
  }

  
   
}
