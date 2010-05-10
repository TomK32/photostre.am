// we kinda assume that the target has a sibling after it to get a 
function fitContentSize(target) {
  // 100px space for the photos in the footer
  max_image_height = Math.max(200, $(window).height() - $(target).offset().top  - ($('body').height() - $(target).next().offset().top ));
  //$('img', target).height(Math.min($('img', target).attr('naturalHeight'), max_image_height - 80));
  $(target).height(max_image_height);
  $(target).width(Math.max(300, $('img', target).width()));
}

$(document).ready(function(){
  $(window).bind('resize', function(event){ fitContentSize('.large'); });
  $(window).bind('load', function(event){ fitContentSize('.large'); });
});
