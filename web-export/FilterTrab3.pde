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
   if(n % 2 == 0)
     throw new Exception();

    generateMatrix(n);
 }

 public void generateMatrix(int n){
  matrix = new float[n][n];
  console.log(matrix);
  for(int i = 0; i < n; i++){
     for(int j = 0 ; j < n; j++){
        matrix[i][j] = 1 / (n*n);
     }
   }
  }
}

 
public class ConvolutionFilter extends Filter{

  protected float[][] matrix;

  void generateMatrix(int n){

  };

  public void setMatrix(float[][] m){

    this.matrix = m;
    int n = m.length;
    float sum = 0.0;
    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        sum = (int) (sum + (int) m[i][j]);
      }
    }

    if(sum == 0){
      return;
    }

    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        m[i][j] = m[i][j]/sum;
      }
    }


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
    console.log(result);
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
MouseSelection mouseSelection;

void setup() {
  size(400, 400, OPENGL);
  // The image file must be in the data folder of the current sketch
  // to load successfully
  inputManager = new InputManager();
  inputManager.requestImage("Selecione uma image: ");

  mouseSelection = new MouseSelection();
  filter = null;
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  background(255);

  if(inputManager.getImage() == null){
    // return;
  }else{
    image(inputManager.getImage(), 0, 0);
  }

  //mouseSelection.displaySelectionBox();

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

void applyFilter(int i, callback){
  if(i == 0){
    result = inputManager.getImage();
    callback();
  }

  if(i == 1)
    filter = new VintageFilter();

  if(i == 2)
    filter = new BlackAndWhiteFilter();

  if(i == 3){

    try{
      filter = new BoxFilter( (int) $('#size-box').val() );
    }catch(e){
      $("#error-box").html("O tamanho da matriz não pode ser par.");
    }

  }


  if(i == 4)
    try{
      filter = new GaussianBlur($('#sigma').val(),$('#size-gaussian').val());
    } catch(e){
      $("#error2-box").html("O tamanho da matriz não pode ser par.");
    }


  if(i == 5)
    filter = new SobelFilter();

  if(i == 6)
    filter = new Crop($("#x-inicial").val(),
                      $("#y-inicial").val(),
                      $("#x-final").val(),
                      $("#y-final").val());

  if(i == 7){
    filter = new ConvolutionFilter(3);

    float[][] matrix;
    matrix = new float[3][3];

    for (int i = 0; i < 3; ++i) {
      for (int j = 0; j < 3; ++j) {
        matrix[i][j] = $("#"+(i+1)+"-"+(j+1)).val();
      }
    }


    filter.setMatrix(matrix);
  }

  if(filter == null){
    result = inputManager.getImage();
  }else{
    result = filter.apply(inputManager.getImage());
  }

  callback();
}

void getImageResult(){
  var object = { 'data': result.pixels, 'width': result.width, 'height': result.height };
  return object;
}


// void mouseClicked(int x, int y) {
//   mouseSelection.mouseClicked(x, y);
// }
//
// void mouseDragged(int x, int y) {
//   console.log(x);
//   console.log(y);
//   mouseSelection.mouseClicked(x, y);
// }

 
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
       tmpImage.resize(width, height);
       img = tmpImage;
    }


}

 
public class MouseSelection{

  int xInicial, yInicial, xFinal, yFinal;

  public MouseSelection(){
    xInicial = 0;
    yInicial = 0;
    xFinal = 0;
    yFinal = 0;
  }

  public void mouseClicked(int x, int y){
    xInicial = x;
    yInicial = y;
    xFinal = x;
    yFinal = y;
  }

  public void mouseDragged(int x, int y){
    xFinal = x;
    yFinal = y;
  }

  public void displaySelectionBox(){
    //stroke(0);
    //rect(xInicial, yInicial, xFinal - xInicial, yFinal - yInicial);
    ellipseMode(CENTER);
    ellipse(xInicial, yInicial, 50, 50);
    //line(xInicial, yInicial, xFinal , yFinal );
  }
}

 
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
