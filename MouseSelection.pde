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
