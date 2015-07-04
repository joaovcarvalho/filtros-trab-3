class VintageFilter extends Filter{

  private PImage vintage;

  VintageFilter(){
    this.vintage = loadImage("vintage.jpg");
  }

  public PImage apply(PImage img){
    PImage result = new PImage(img.width, img.height);
    for(int i = 0; i < img.width; i++){
      for(int j = 0; j < img.height; j++){

          if(!shouldApplyPixel( i, j )){
            result.set(i,j, img.get(i,j)) ;
            continue;
          }

         color imgColor = img.get(i,j);
         color imgVintageColor = this.vintage.get(i,j);

         float r = red(imgColor)*0.6 + red(imgVintageColor)*0.4;
         float g = green(imgColor)*0.6 + green(imgVintageColor)*0.4;
         float b = blue(imgColor)*0.6 + blue(imgVintageColor)*0.4;
         result.set(i,j, color(r,g,b));
      }
    }

    return result;
  }
}
