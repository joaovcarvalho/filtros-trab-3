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
