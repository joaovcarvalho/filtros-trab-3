function readURL(input) {

    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#blah').attr('src', e.target.result);
            $('#blah').load(function(){

              var sketch = Processing.getInstanceById(getProcessingSketchId());
              sketch.setApplied(false);
              
              var img = $('#blah')[0];
              var canvas = $('<canvas/>')[0];
              canvas.width = img.width;
              canvas.height = img.height;
              canvas.getContext('2d').drawImage(img, 0, 0, img.width, img.height);

              // Inicializa a image no processing
              sketch.getInputManager().initImage(img.width, img.height);

              var imgData = canvas.getContext('2d').getImageData(0, 0, img.width, img.height);
              for (var i=0;i<imgData.data.length;i+=4)
              {
                var red = imgData.data[i];
                var green = imgData.data[i+1];
                var blue = imgData.data[i+2];
                var alpha = imgData.data[i+3];
                // Atualiza o pixel i com a cor dele
                sketch.getInputManager().setPixel(i/4, red, green, blue, alpha);
              }

              // Finaliza e passa a usar a imagem carregada
              sketch.getInputManager().updatePixels();
            })

        }

        reader.readAsDataURL(input.files[0]);
    }
}


var timeout = setTimeout(function(){

     if (typeof $ !== 'undefined') {
          // the variable is defined
          $(function(){
            $("#imgInp").change(function(){
              readURL(this);
            });
          })

          clearTimeout(timeout);
     }


  }, 500);
