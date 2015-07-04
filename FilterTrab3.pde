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
