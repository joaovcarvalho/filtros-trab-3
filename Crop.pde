public class Crop extends Filter{

  int xInicial; int yInicial; int xFinal; int yFinal;

  public Crop(int xInicial, int yInicial, int xFinal, int yFinal){
    this.xInicial = xInicial;
    this.yInicial = yInicial;
    this.xFinal = xFinal;
    this.yFinal = yFinal;
  }

  public PImage apply(PImage img){
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
