public class GaussianBlur extends ConvolutionFilter{
  private float sigma = 1;

 GaussianBlur(int n, float s){
    if(n % 2 == 0)
       throw new Exception();

    this.sigma = s;
    generateMatrix(n);
 }

 public void generateMatrix(int n){
    matrix = new float[n][n];
    int mean = (int)(n/2);
    float sum = 0.0;
    for(int i = 0; i < n; i++){
       for(int j = 0 ; j < n; j++){
          matrix[i][j] = exp( -0.5 * ( pow( (i-mean) /sigma, 2.0) + pow( (j-mean)/sigma,2.0) ) )
                         / (2 * PI * sigma * sigma);

          sum += matrix[i][j];
       }
     }

     for (int i = 0; i < n; ++i) {
       for (int j = 0; j < n; ++j) {
         matrix[i][j] /= sum;
       }
     }
 }
}
