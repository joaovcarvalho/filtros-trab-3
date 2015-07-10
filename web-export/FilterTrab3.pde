public class BlackAndWhiteFilter extends Filter{

 public PImage apply(PImage img){
    PImage result = new PImage(img.width, img.height);

    for(int i = 0; i< img.pixels.length; i++){
      if(!shouldApplyPixel( (int) ( i % img.width), (int) (i/img.width) )){
        result.pixels[i] = img.pixels[i];
        continue;
      }
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
  for(int i = 0; i < n; i++){
     for(int j = 0 ; j < n; j++){
        matrix[i][j] = 1 / (n*n);
     }
   }
  }
}

 
public class CCielab{
  float L;
  float a;
  float b;

  public CCielab(color rgb) {

    // RGB -> XYZ
    float var_R = (red(rgb)   / 255 );
    float var_G = (green(rgb) / 255 );
    float var_B = (blue(rgb)  / 255 );

    if ( var_R > 0.04045 ) var_R = pow(( var_R + 0.055 ) / 1.055, 2.4);
    else                   var_R = var_R / 12.92;
    if ( var_G > 0.04045 ) var_G = pow(( var_G + 0.055 ) / 1.055, 2.4);
    else                   var_G = var_G / 12.92;
    if ( var_B > 0.04045 ) var_B = pow(( var_B + 0.055 ) / 1.055, 2.4);
    else                   var_B = var_B / 12.92;

    var_R = var_R * 100;
    var_G = var_G * 100;
    var_B = var_B * 100;

    float X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
    float Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
    float Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;

    // XYZ -> CIE-L*ab

    float var_X = X / 95.047;
    float var_Y = Y / 100.000;
    float var_Z = Z / 108.883;

    if ( var_X > 0.008856 ) var_X = pow(var_X, 1./3);
    else                    var_X = ( 7.787 * var_X ) + ( 16. / 116. );
    if ( var_Y > 0.008856 ) var_Y = pow(var_Y, 1./3);
    else                    var_Y = ( 7.787 * var_Y ) + ( 16. / 116. );
    if ( var_Z > 0.008856 ) var_Z = pow(var_Z, 1./3);
    else                    var_Z = ( 7.787 * var_Z ) + ( 16. / 116. );

    L = ( 116. * var_Y ) - 16;
    a = 500. * ( var_X - var_Y );
    b = 200. * ( var_Y - var_Z );
  }

  public float deltaE(CCielab col) {
    float whtl = 1.;  // Weighting factors depending
    float whtc = 1.;  // on the application (1 = default)
    float whth = 1.;

    float xC1 = sqrt( (a*a) + (b*b) );
    float xC2 = sqrt( (col.a*col.a) + (col.b*col.b) );
    float xDL = col.L - L;
    float xDC = xC2 - xC1;
    float xDE = sqrt(((L-col.L)*(L-col.L))
                       +((a-col.a)*(a-col.a))+((b-col.b)*(b-col.b)));
    float xDH = 0;

    if (sqrt(xDE)>(sqrt(abs(xDL))+sqrt(abs(xDC)))) {
      xDH = sqrt((xDE*xDE)-(xDL*xDL)-(xDC*xDC));
    }

    float xSC = 1 + ( 0.045 * xC1 );
    float xSH = 1 + ( 0.015 * xC1 );

    xDL /= whtl;
    xDC /= whtc * xSC;
    xDH /= whth * xSH;
    float Delta_E94 = sqrt(pow(xDL,2) + pow(xDC,2) + pow(xDH,2));

    return(Delta_E94);
  }
}

 
public class ConvolutionFilter extends Filter{

  protected float[][] matrix;

  void generateMatrix(int n){

  };

  public float[][] getMatrix(){
    return this.matrix;
  }

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

        if(!shouldApplyPixel( i, j )){
          result.set(i,j, img.get(i,j)) ;
          continue;
        }

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
    return result;
  }


}

 
public class Filter{

  MouseSelection ms = null;

  public void setMouseSelection(MouseSelection ms){
    if(ms.isSelected()){
      this.ms = ms;
    }else{
      this.ms = null;
    }
  }

  public boolean shouldApplyPixel(int x, int y){
    if(this.ms == null)
      return true;

    return ms.isPixelSelected(x,y);
  }

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
  size(400, 400);
  // The image file must be in the data folder of the current sketch
  // to load successfully
  UnitTests ut = new UnitTests();
  ut.runTests();

  inputManager = new InputManager();
  inputManager.requestImage("Selecione uma image: ");

  mouseSelection = new MouseSelection();
  filter = null;
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  background(255);
  if(inputManager.getImage() != null){
    image(inputManager.getImage(), 0, 0);
  }

  mouseSelection.displaySelectionBox();
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
      filter = new GaussianBlur( (int) $('#size-gaussian').val(), (int) $('#sigma').val());
    } catch(e){
      $("#error2-box").html("O tamanho da matriz não pode ser par.");
    }


  if(i == 5)
    filter = new SobelFilter();

  if(i == 6){

    int xi, yi, xf, yf;
    if(mouseSelection.isSelected()){
      xi = mouseSelection.getSelectedInitial().x;
      yi = mouseSelection.getSelectedInitial().y;
      xf = mouseSelection.getSelectedFinal().x;
      yf = mouseSelection.getSelectedFinal().y;
    }else{
      xi = $("#x-inicial").val();
      yi = $("#y-inicial").val();
      xf = $("#x-final").val();
      yf = $("#y-final").val();
    }

    filter = new Crop(xi,yi, xf, yf);

  }

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

  if(i == 8){
    filter = new Resize( (int) $("#width").val(), (int) $("#height").val());
  }

  if(i == 9)
    filter = new OptimizationFilter();

  if(filter == null){
    result = inputManager.getImage();
  }else{
    filter.setMouseSelection(mouseSelection);
    result = filter.apply(inputManager.getImage());
  }

  callback();
}

void getImageResult(){
  var object = { 'data': result.pixels, 'width': result.width, 'height': result.height };
  return object;
}

 void mouseClicked() {
  mouseSelection.mouseClicked(mouseX, mouseY);
}

void mouseDragged() {
  mouseSelection.mouseDragged(mouseX, mouseY);
}

void mouseReleased(){
  mouseSelection.mouseReleased(mouseX, mouseY);
}

 
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

  PVector mouseInitial;
  PVector mouseFinal;

  PVector selectedInitial;
  PVector selectedFinal;

  boolean selecting = false;
  boolean selected = false;

  public MouseSelection(){
    mouseInitial = new PVector(0,0);
    mouseFinal = new PVector(0,0);
    selectedInitial = new PVector(0,0);
    selectedFinal = new PVector(0,0);
  }

  public void mouseClicked(int x, int y){
    mouseInitial = new PVector(0,0);
    mouseFinal = new PVector(0,0);
    selectedInitial = new PVector(0,0);
    selectedFinal = new PVector(0,0);
    selected = false;
  }

  public void mouseDragged(int x, int y){
    if(mouseInitial.x == 0 && mouseInitial.y == 0){
      mouseInitial = new PVector(x,y);
      selecting = true;
      selectedInitial = new PVector(0,0);
      selectedFinal = new PVector(0,0);
    }

    mouseFinal = new PVector(x,y);
  }

  public void mouseReleased(int x , int y){
    selectedInitial = mouseInitial;
    selectedFinal = mouseFinal;


    mouseInitial = new PVector(0,0);
    mouseFinal = new PVector(0,0);
    selecting = false;
    selected = true;
    if(selectedInitial.x == selectedFinal.x && selectedInitial.y == selectedFinal.y){
      selected = false;
    }
  }

  public void displaySelectionBox(){
    fill(255,0,0, 100);
    // stroke(255,0,0);
    noStroke();
    rectMode(CORNER);
    if(selecting){
      rect(mouseInitial.x, mouseInitial.y, mouseFinal.x - mouseInitial.x, mouseFinal.y - mouseInitial.y);
    }else{
      rect(selectedInitial.x, selectedInitial.y, selectedFinal.x - selectedInitial.x, selectedFinal.y - selectedInitial.y);
    }
  }

  public boolean isSelected(){
    return selected;
  }

  public PVector getSelectedInitial(){
    return selectedInitial;
  }

  public PVector getSelectedFinal(){
    return selectedFinal;
  }

  public boolean isPixelSelected(int x, int y){
    return (x < selectedFinal.x) &&
           (y < selectedFinal.y) &&
           (x > selectedInitial.x) &&
           (y > selectedInitial.y);
  }
}

 
public class OptimizationFilter extends Filter{

  public OptimizationFilter(){

  }

  public PImage apply(PImage img){
    PImage result = new PImage(img.width, img.height);
    var colors = findColorsByPopulairity(img);

    for(int i = 0; i < img.width; i++){
      for(int j = 0; j < img.height; j++){

        var current_color = img.get(i,j);
        var min = Number.POSITIVE_INFINITY;
        var result_color = color(255,0,0);

        for (var object in colors){
          float delta = Math.abs( Math.abs(current_color) - Math.abs(object[0]));
          console.log(delta);

          if(delta < min){
            min = delta;
            result_color = object[0];
          }
        }

        result.set(i,j, result_color);
      }
    }

    result.updatePixels();
    return result;
  }

  public Object[] findColorsByPopulairity(PImage img){
    var colors = new Object();

    for(int i = 0; i < img.width; i++){
      for(int j = 0; j < img.height; j++){
        int c = color(img.get(i,j));
        if(c in colors){
          colors[c] = colors[c] + 1;
        }else{
          colors[c] = 1;
        }
      }
    }


    var sortable = [];
    for (var object in colors)
          sortable.push([object, colors[object]])
    sortable.sort(function(a, b) {return b[1] - a[1]});


    return sortable.slice(0,256);
  }


}

 
public class Resize extends Filter{

  int imageWidth, imageHeight;
  PImage result;
  PImage img;
  float wr;
  float hr;

  HashMap hm = new HashMap();

  public Resize(int w, int h){
    imageWidth = w;
    imageHeight = h;

    result = new PImage(imageWidth, imageHeight);

  }

  public PImage apply(PImage img){
    this.img = img;
    wr = (imageWidth/ img.width);
    hr = (imageHeight/ img.height);

    for(int i = 0; i < result.width; i++){
      for(int j = 0; j < result.height; j++){
        result.set(i,j, interpolatePixel(i,j));
      }
    }

    result.updatePixels();
    return result;
  }

  private color interpolatePixel(int i, int j){
    if( isInt((i/wr)) && isInt((j/hr)) ){
      int x = (int) (i/wr);
      int y = (int) (j/hr);

      return img.get(x,y);
    }else{

      float r = interpolateComponent(i,j, 'red');
      float g = interpolateComponent(i,j, 'green');
      float b = interpolateComponent(i,j, 'blue');

      return color(r,g,b);
    }
  }

  private boolean isInt(float n) {
    return n % 1 === 0;
  }

  private float interpolateComponent(int i, int j, String component){
    float x1 = (int) (i/wr);
    float y1 = (int) (j/hr);
    float x2 = x1 + 1;
    float y2 = y1 + 1;

    float q11 = getComponentQ(x1, y1, component);
    float q21 = getComponentQ(x2, y1, component);
    float q12 = getComponentQ(x1, y2, component);
    float q22 = getComponentQ(x2, y1, component);

    x1 = (int) (x1 * wr);
    y1 = (int) (y1 * hr);
    x2 = (int) (x2 * wr);
    y2 = (int) (y2 * hr);

    float r1 = ( (x2 - i)/(x2 - x1) ) * q11 + ( (i - x1)/(x2 - x1) ) * q21 ;
    float r2 = ( (x2 - i)/(x2 - x1) ) * q12 + ( (i - x1)/(x2 - x1) ) * q22;
    float c = ( (y2 - j)/(y2 - y1))*r1 + ((j - y1)/(y2 - y1))*r2;
    return c;
  }

  private float getComponentQ(float x, float y, String component){
    float q = img.get( (int) x, (int) y  );
    if(component == 'red')
      return red(q);
    if(component == 'blue')
      return blue(q);
    if(component == 'green')
      return green(q);
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

         if(!shouldApplyPixel( i, j )){
           result.set(i,j, img.get(i,j)) ;
           continue;
         }

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

 
public class UnitTests {

  private boolean passed = true;

  public void runTests(){
    console.log("============ UNIT TESTS =============== ");

    ConvolutionFilter b ;

    b = new BoxFilter(3);
    assertTrue( 1 - sumMatrix(b.getMatrix()) < 0.000001 );

    b = new GaussianBlur(3,1);
    assertTrue( 1 - sumMatrix(b.getMatrix()) < 0.000001 );

    terminateTests();
  }

  public void terminateTests(){
    if(passed){
      console.log("ALL TESTS PASSING ! OK. YOU'RE GOOD TO GO!");
    }
  }

  public boolean assertTrue(boolean b){
    if(!b){
      console.log("ASSERTION FAILED");
      passed = false;
    }
  }

  public float sumMatrix(float[][] m){
    float sum = 0.0;
    for(int i = 0; i < m.length; i++)
      for(int j = 0; j < m[i].length; j++ )
        sum += m[i][j];

    return sum;
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
