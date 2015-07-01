public class SobelFilter extends Filter{

  ConvolutionFilter gx;
  ConvolutionFilter gy;

  public PImage apply(PImage img){
     gx = new ConvolutionFilter();
     gy = new ConvolutionFilter();
     gx.setMatrix([[-1, 0, +1], [-2, 0, +2], [-1, 0, +1]]);
     gy.setMatrix([[+1, +2, +1], [0,0,0], [-1, -2, -1]]);

     gxResult = gx.apply(img);
     gyResult = gy.apply(img);

     int filterRadius = (int) (3 / 2);

     loadPixels();
     PImage result = new PImage(img.width, img.height);

     for(int i = 0; i < img.width; i++){
       for(int j = 0; j < img.height; j++){

         newRed = 0.0;
         newBlue = 0.0;
         newGreen = 0.0;

         for(int fi = 0; fi < 3; fi++){
          for(int fj = 0 ; fj < 3; fj++){

              color magX = gxResult.get(
                  this.bound(i + fi - filterRadius, img.width),
                  this.bound(j + fj - filterRadius, img.height)
                );

              color magY = gyResult.get(
                  this.bound(i + fi - filterRadius, img.width),
                  this.bound(j + fj - filterRadius, img.height)
                );

              newRed += sqrt( pow(red(magX),2) + pow(red(magY),2));
              newBlue += sqrt( pow(blue(magX),2) + pow(blue(magY),2));
              newGreen += sqrt( pow(green(magX),2) + pow(green(magY),2));

            }
          }

          result.set(i,j, color( newRed, newGreen, newBlue  ));
       }
     }

     return result;
  }

}
