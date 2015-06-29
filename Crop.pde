public class Crop{

  public PImage apply(PImage img, int xInicial, int yInicial, int xFinal, int yFinal){
    PImage result = new PImage(xFinal - xInicial, yFinal - yInicial);
    for(int i = xInicial; i < xFinal; i++){
      for(int j = yInicial; j < yFinal; j++){
        result.set(i - xInicial, j - yInicial, img.get(i,j));
      }
    }

    result.updatePixels();
    return result;
  }


}
