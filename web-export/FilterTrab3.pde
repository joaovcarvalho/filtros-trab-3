public class BlackAndWhiteFilter extends Filter{
 
 public PImage apply(PImage img){
    PImage result = new PImage(img.width, img.height);
  
    for(int i = 0; i< img.pixels.length; i++){
      color c = color(img.pixels[i]);
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      float media = (r + g + b)/3;
      result.pixels[i] = color(media,media, media);
    }
    
    result.updatePixels();
    return result;
 } 
  
}

 
public class BoxFilter extends ConvolutionFilter{

 BoxFilter(int n){
    generateMatrix(n);
 }

 public void generateMatrix(int n){
  matrix = new float[n][n];
  for(int i = 0; i < n; i++){
     for(int j = 0 ; j < n; j++){
        matrix[i][j] = 1 / (n*n);
     }
   }

   console.log(matrix);
  }
}

 
public abstract class ConvolutionFilter extends Filter{
  
 abstract void generateMatrix(int n); 

 protected float[][] matrix;
 
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
               
             newRed += matrix[fi][fj] * red(old);
             newBlue += matrix[fi][fj] * blue(old);
             newGreen += matrix[fi][fj] * green(old);
             
           }
         }
         
         result.set(i,j, color( newRed, newGreen, newBlue  ));
      }  
    }
   
    updatePixels();
    return result;
 } 
  
}

 
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

 
public class Filter{
  
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

 
/**
 *    This examples shows you how to interact with the HTML5 range input. <br />
 *    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
 *    <form id="form1" runat="server">
 *        <input type='file' id="imgInp" />
 *        <img id="blah" src="#" alt="your image" style="display:none;" />
 *    </form>
 *    (Slider by Firefox currently not supported.) <br />
 */

 /* @pjs preload="vintage.jpg" */

InputManager inputManager;
Filter filter;
PImage result;

boolean applied = false;

void setup() {
  size(800, 400);
  // The image file must be in the data folder of the current sketch
  // to load successfully
  inputManager = new InputManager();
  inputManager.requestImage("Selecione uma image: ");

  filter = new BoxFilter(5);
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  background(255);
  if(inputManager.getImage() == null){
    return;
  }else{
    if(!applied){
      result = filter.apply(inputManager.getImage());
      applied = true;
    }

    image(inputManager.getImage(), 0, 0);
    image(result, width/2, 0);
  }
}


void printMatrix(float[][] m){
  for(int i = 0; i < m.length; i++){
    for(int j =0; j < m[i].length; j++){
      print(m[i][j] + " ");
    }
    println("");
  }

}

 /* this is being called from JavaScript when the range slider is changed */
InputManager getInputManager(){
   return inputManager;
}

void setApplied(boolean b){
  applied = b;
}

void applyFilter(int i){

  if(i == 1)
    filter = new VintageFilter();

  if(i == 2)
    filter = new BlackAndWhiteFilter();

  if(i == 3)
    filter = new BoxFilter(3);

  if(i == 4)
    filter = new GaussianBlur(5,5);

  applied = false;
}

 
public class GaussianBlur extends ConvolutionFilter{
  private float sigma = 1;

 GaussianBlur(int n, float s){
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

 
public class InputManager {

	PImage tmpImage;
    PImage img;
	File file;

	public InputManager () {
		tmpImage = null;
                img = null;
	}

	public void requestImage(String text){
		try {
           selectInput(text, "callback", file, this);
        } catch (Exception e) {
           //println("selectInput não suportado.");     
        }
	}

	public void callback(File selection){
		  if (selection == null) {
		    println("Window was closed or the user hit cancel.");
		  } else {
		    img = loadImage(selection.getAbsolutePath());
		  }
	}

	public PImage getImage(){
		return this.img;
	}

    public void initImage(int width, int height){
       tmpImage = new PImage(width, height);
    }

    public void setWidthImage(int width){
      tmpImage.width = width;
    }

    public void setHeightImage(int height){
      tmpImage.height = height;
    }

    public void setPixel(int i, int r, int g, int b){
       tmpImage.pixels[i] = color(r,g,b);
    }

    public void updatePixels(){
       tmpImage.updatePixels();
       tmpImage.resize(width/2, height);
       img = tmpImage;
    }


}

 
class VintageFilter extends Filter{

  private PImage vintage;

  VintageFilter(){
    this.vintage = loadImage("vintage.jpg");
  }

  public PImage apply(PImage img){
    PImage result = new PImage(img.width, img.height);
    for(int i = 0; i < img.width; i++){
      for(int j = 0; j < img.height; j++){
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
