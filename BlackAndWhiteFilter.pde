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
