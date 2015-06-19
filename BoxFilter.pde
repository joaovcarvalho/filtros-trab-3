public class BoxFilter extends Filter{
  
 private float[][] matrix;
 
 BoxFilter(int n){
   matrix = new float[n][n];
   for(int i = 0; i < n; i++){
     for(int j = 0 ; j < n; j++){
        matrix[i][j] = 1; 
     }
   }
 }
 
 public PImage apply(PImage img){
    int filterSize = matrix.length;
    int filterRadius = (int) filterSize / 2;
    
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
               
             newRed += matrix[fi][fj] * red(old);
             newBlue += matrix[fi][fj] * blue(old);
             newGreen += matrix[fi][fj] * green(old);
             
           }
         }
         
         result.set(i,j, color( round(newRed/(filterSize*filterSize)),round(newGreen/(filterSize*filterSize)),round(newBlue/(filterSize*filterSize))  ));
      }  
    }
   
    updatePixels();
    return result;
 } 
  
}
