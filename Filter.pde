public class Filter{
  
 public PImage apply(PImage img){
    return img;
 }
 
 public int bound(int i, int bound){
    if( i < 0)
     return 0;
    
    if (i < bound)
      return i;
      
    return bound - 1;
 }
  
}
