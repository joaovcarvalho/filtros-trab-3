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

void setup() {
  size(400, 400);
  // The image file must be in the data folder of the current sketch
  // to load successfully
  inputManager = new InputManager();
  inputManager.requestImage("Selecione uma image: ");

  filter = new SobelFilter();
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  background(255);
  if(inputManager.getImage() == null){
    return;
  }else{
    image(inputManager.getImage(), 0, 0);
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

void applyFilter(int i, callback){
  if(i == 0){
    result = inputManager.getImage();
    callback();
  }

  if(i == 1)
    filter = new VintageFilter();

  if(i == 2)
    filter = new BlackAndWhiteFilter();

  if(i == 3)
    filter = new BoxFilter(3);

  if(i == 4)
    filter = new GaussianBlur(5,5);

  result = filter.apply(inputManager.getImage());
  callback();
}

void getImageResult(){
  var object = { 'data': result.pixels, 'width': result.width, 'height': result.height };
  return object;
}
