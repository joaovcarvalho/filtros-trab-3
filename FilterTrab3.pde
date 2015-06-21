/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */
 
InputManager inputManager;
Filter filter;

void setup() {
  size(800, 500);
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  inputManager = new InputManager();
  inputManager.requestImage("Selecione uma image: ");

  filter = new BoxFilter(10);
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  background(255);
  if(inputManager.getImage() == null){
    return;
  }

  image(inputManager.getImage(), 0, 0, width/2, height);
  
  PImage result = filter.apply(inputManager.getImage());
  
  image(result, width/2, 0, width/2, height);
}


void printMatrix(float[][] m){
  for(int i = 0; i < m.length; i++)
    for(int j =0; j < m[i].length; j++)
      println(m[i][j]);
}
