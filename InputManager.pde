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
           println("selectInput não suportado.");     
        }
	}

	public void callback(File selection){
		  if (selection == null) {
		    println("Window was closed or the user hit cancel.");
		  } else {
		    println("User selected " + selection.getAbsolutePath());
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
       tmpImage.resize(200,200);
       img = tmpImage;
    }

}
