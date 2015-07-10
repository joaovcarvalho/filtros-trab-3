public class OptimizationFilter extends Filter{

  public OptimizationFilter(){

  }

  public PImage apply(PImage img){
    PImage result = new PImage(img.width, img.height);
    var colors = findColorsByPopulairity(img);

    for(int i = 0; i < img.width; i++){
      for(int j = 0; j < img.height; j++){

        var current_color = img.get(i,j);
        var min = Number.POSITIVE_INFINITY;
        var result_color = color(255,0,0);

        for (var object in colors){
          float delta = Math.abs( Math.abs(current_color) - Math.abs(object[0]));
          console.log(delta);

          if(delta < min){
            min = delta;
            result_color = object[0];
          }
        }

        result.set(i,j, result_color);
      }
    }

    result.updatePixels();
    return result;
  }

  public Object[] findColorsByPopulairity(PImage img){
    var colors = new Object();

    for(int i = 0; i < img.width; i++){
      for(int j = 0; j < img.height; j++){
        int c = color(img.get(i,j));
        if(c in colors){
          colors[c] = colors[c] + 1;
        }else{
          colors[c] = 1;
        }
      }
    }


    var sortable = [];
    for (var object in colors)
          sortable.push([object, colors[object]])
    sortable.sort(function(a, b) {return b[1] - a[1]});


    return sortable.slice(0,256);
  }


}
