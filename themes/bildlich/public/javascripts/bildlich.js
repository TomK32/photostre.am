
function horizontalScroll(event) {
  delta = event.detail ? event.detail * (-50) : event.wheelDelta / 30
  scrollOffset = 10 * (delta / (-50));
  element = $(event.target).closest('.horizonalScroll');
  $(element).scrollLeft( $(element).scrollLeft() + scrollOffset);

  event.preventDefault();
  event.stopPropagation()
}

$(document).ready(function(){
  $('#background_image width').width($(window).width());
  $('#background_image height').width($(window).height());
  $('.photo').live('click', function(){
  });
  $('#albums, #photos').addClass('horizonalScroll');
  $('.horizonalScroll').live((/Firefox/i.test(navigator.userAgent)) ? "DOMMouseScroll" : "mousewheel", horizontalScroll);
  $('.horizonalScroll').css('overflow', 'hidden');
});
