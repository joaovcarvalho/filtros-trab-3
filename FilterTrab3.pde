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
