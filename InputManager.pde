public class InputManager {

	PImage tmpImage;
	File file;

	public InputManager () {
		tmpImage = null;
	}

	public void requestImage(String text){
		selectInput(text, "callback", file, this);
	}

	public void callback(File selection){
		  if (selection == null) {
		    println("Window was closed or the user hit cancel.");
		  } else {
		    println("User selected " + selection.getAbsolutePath());
		    tmpImage = loadImage(selection.getAbsolutePath());
		  }
	}

	public PImage getImage(){
		return this.tmpImage;
	}

}