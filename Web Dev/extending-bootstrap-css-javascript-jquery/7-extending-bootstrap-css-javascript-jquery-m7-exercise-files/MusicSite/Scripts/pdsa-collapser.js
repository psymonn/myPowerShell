// **************************** //
// BEGIN: PDSA Collapser Script //
// **************************** //
$(document).ready(function () {
  var pdsaCollapser = $("[data-pdsa-collapser-name]");
  
  for (var i = 0; i < pdsaCollapser.length; i++) {
    var name = pdsaCollapser[i].id;
    var open = $("#" + name)
      .data("pdsa-collapser-open");
    var close = $("#" + name)
      .data("pdsa-collapser-close");
    
    // Add 'open' icon to all panels
    $("#" + name + " .pdsa-panel-toggle")
      .addClass(open);
    
    // Find any panel's that have the class '.in',
    // remove the 'open' glyph and add the 'close' glyph
    var list = $("#" + name + " .in");
    for (var index = 0; index < list.length; index++) {
      $($("a[href='#" + $(list[index]).attr("id") + "']"))
        .next(".pdsa-panel-toggle")
        .removeClass(open)
        .addClass(close);
    }

    // Hook into 'hide' event
    $("#" + name).on('hide.bs.collapse', function (e) {
      var parent = $("#" + e.target.id).parents(".panel-group");
      
      $("#" + e.target.id).prev().find(".pdsa-panel-toggle")
        .removeClass($(parent).data("pdsa-collapser-close"))
        .addClass($(parent).data("pdsa-collapser-open"));
    });

    // Hook into 'show' event
    $("#" + name).on('show.bs.collapse', function (e) {
      var parent = $("#" + e.target.id)
        .parents(".panel-group");
      
      $("#" + e.target.id).prev().find(".pdsa-panel-toggle")
        .removeClass($(parent).data("pdsa-collapser-open"))
        .addClass($(parent).data("pdsa-collapser-close"));
    });
  }
});
// ************************** //
// END: PDSA Collapser Script //
// ************************** //