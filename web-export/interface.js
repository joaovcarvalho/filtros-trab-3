$(function(){
  $("#applyFilterBtn").click(function(){
    var active = $(".tabulous_active")[0];
    var filter = $(active);

    var sketch = Processing.getInstanceById(getProcessingSketchId());
    sketch.applyFilter(filter.attr("id"));
  });
});
