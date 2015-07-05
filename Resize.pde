public class Resize extends Filter{

  int imageWidth, imageHeight;
  PImage result;
  PImage img;
  float wr;
  float hr;

  HashMap hm = new HashMap();

  public Resize(int w, int h){
    imageWidth = w;
    imageHeight = h;

    result = new PImage(imageWidth, imageHeight);

  }

  public PImage apply(PImage img){
    this.img = img;
    wr = (imageWidth/ img.width);
    hr = (imageHeight/ img.height);

    for(int i = 0; i < result.width; i++){
      for(int j = 0; j < result.height; j++){
        result.set(i,j, interpolatePixel(i,j));
      }
    }

    result.updatePixels();
    return result;
  }

  private color interpolatePixel(int i, int j){
    if( isInt((i/wr)) && isInt((j/hr)) ){
      int x = (int) (i/wr);
      int y = (int) (j/hr);

      return img.get(x,y);
    }else{

      float r = interpolateComponent(i,j, 'red');
      float g = interpolateComponent(i,j, 'green');
      float b = interpolateComponent(i,j, 'blue');

      return color(r,g,b);
    }
  }

  private boolean isInt(float n) {
    return n % 1 === 0;
  }

  private float interpolateComponent(int i, int j, String component){
    float x1 = (int) (i/wr);
    float y1 = (int) (j/hr);
    float x2 = x1 + 1;
    float y2 = y1 + 1;

    float q11 = getComponentQ(x1, y1, component);
    float q21 = getComponentQ(x2, y1, component);
    float q12 = getComponentQ(x1, y2, component);
    float q22 = getComponentQ(x2, y1, component);

    x1 = (int) (x1 * wr);
    y1 = (int) (y1 * hr);
    x2 = (int) (x2 * wr);
    y2 = (int) (y2 * hr);

    float r1 = ( (x2 - i)/(x2 - x1) ) * q11 + ( (i - x1)/(x2 - x1) ) * q21 ;
    float r2 = ( (x2 - i)/(x2 - x1) ) * q12 + ( (i - x1)/(x2 - x1) ) * q22;
    float c = ( (y2 - j)/(y2 - y1))*r1 + ((j - y1)/(y2 - y1))*r2;
    return c;
  }

  private float getComponentQ(float x, float y, String component){
    float q = img.get( (int) x, (int) y  );
    if(component == 'red')
      return red(q);
    if(component == 'blue')
      return blue(q);
    if(component == 'green')
      return green(q);
  }

}
