var loadImageIntoResult = function(){
  // A partir daqui é código para pegar o resultado e desenhar em outro canvas
  var sketch = Processing.getInstanceById(getProcessingSketchId());

  var psImage = sketch.getImageResult();

  var canvas = $('#result-canvas')[0];
  canvas.width = psImage.width;
  canvas.height = psImage.height;

  var ctx = canvas.getContext('2d');

  //set background color
  ctx.fillStyle = 255;

  //draw background / rect on entire canvas
  ctx.fillRect(0,0,psImage.width,psImage.height);

  var imgData = ctx.getImageData(0, 0, psImage.width, psImage.height);
  var data = imgData.data;

  for (var i = 0; i < data.length; i += 4) {
    var r = (psImage.data[i/4] >> 16) & 0xFF;  // Faster way of getting red(argb)
    var g = (psImage.data[i/4]  >> 8) & 0xFF;   // Faster way of getting green(argb)
    var b = psImage.data[i/4]  & 0xFF

    data[i]     = r;     // red
    data[i + 1] = g; // green
    data[i + 2] = b; // blue
  }

  ctx.putImageData(imgData, 0, 0);
};
