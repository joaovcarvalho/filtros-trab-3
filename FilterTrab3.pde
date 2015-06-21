/**
 *    This examples shows you how to interact with the HTML5 range input. <br />
 *    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
 *    <form id="form1" runat="server">
 *        <input type='file' id="imgInp" />
 *        <img id="blah" src="#" alt="your image" style="display:none;" />
 *    </form>
 *    (Slider by Firefox currently not supported.) <br />
 */
 
InputManager inputManager;
Filter filter;

void setup() {
  size(800, 600);
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  inputManager = new InputManager();
  inputManager.requestImage("Selecione uma image: ");

  filter = new GaussianBlur(7, 20);
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
