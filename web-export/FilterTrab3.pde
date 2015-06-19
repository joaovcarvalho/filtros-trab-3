/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */
 
PImage img = loadImage("moonwalk.jpg");
PImage vintageImage = loadImage("moonwalk.jpg");
Filter filter;

void setup() {
  size(800, 500);
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  selectInput("Select the image:", "fileSelected");
  selectInput("Select the vintage image:", "fileSeletectedVintage");
}

void fileSeletectedVintage(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    vintageImage = loadImage(selection.getAbsolutePath());  
    //size(img.width*2, img.height*2);
    vintageImage.resize(width/2, height);
    filter = new VintageFilter(vintageImage);
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    img = loadImage(selection.getAbsolutePath());  
    //size(img.width*2, img.height*2);
    img.resize(width/2, height);
  }
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  background(255);
  if(img == null)
    return;
  
  image(img, 0, 0);
  
  
  PImage result = filter.apply(img);
  
  image(result, width/2, 0);
}


void printMatrix(float[][] m){
  for(int i = 0; i < m.length; i++)
    for(int j =0; j < m[i].length; j++)
      println(m[i][j]);
}
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
class VintageFilter extends Filter{
  
  private PImage vintage;
  
  VintageFilter(PImage vintage){
    this.vintage = vintage;
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



