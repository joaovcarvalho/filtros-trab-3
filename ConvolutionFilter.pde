public class ConvolutionFilter extends Filter{

  protected float[][] matrix;

  void generateMatrix(int n){

  };

  public void setMatrix(float[][] m){
    this.matrix = m;
  }

 public PImage apply(PImage img){
    int filterSize = matrix.length;
    int filterRadius = (int) (filterSize / 2);

    loadPixels();
    PImage result = new PImage(img.width, img.height);

    float newRed = 0.0;
    float newBlue = 0.0;
    float newGreen = 0.0;

    for(int i = 0; i < img.width; i++){
      for(int j = 0; j < img.height; j++){

        newRed = 0.0;
        newBlue = 0.0;
        newGreen = 0.0;

        for(int fi = 0; fi < filterSize; fi++){
         for(int fj = 0 ; fj < filterSize; fj++){

             color old = img.get(
                 this.bound(i + fi - filterRadius, img.width),
                 this.bound(j + fj - filterRadius, img.height)
               );

             newRed += this.matrix[fi][fj] * red(old);
             newBlue += this.matrix[fi][fj] * blue(old);
             newGreen += this.matrix[fi][fj] * green(old);

           }
         }

         result.set(i,j, color( newRed, newGreen, newBlue  ));
      }
    }

    updatePixels();
    return result;
 }

}
