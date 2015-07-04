public class Filter{

  MouseSelection ms = null;

  public void setMouseSelection(MouseSelection ms){
    if(ms.isSelected()){
      this.ms = ms;
    }else{
      this.ms = null;
    }
  }

  public boolean shouldApplyPixel(int x, int y){
    if(this.ms == null)
      return true;

    return ms.isPixelSelected(x,y);
  }

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
