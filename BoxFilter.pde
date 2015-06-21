public class BoxFilter extends ConvolutionFilter{

 BoxFilter(int n){
    generateMatrix(n);
 }

 public void generateMatrix(int n){
  matrix = new float[n][n];
  for(int i = 0; i < n; i++){
     for(int j = 0 ; j < n; j++){
        matrix[i][j] = 1 / n*n; 
     }
   }
  }
}
