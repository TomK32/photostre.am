/*
$(document).ready(function(){
  $('#photos .photo .info').hide();
  $('#photos .photo').each(function(element) {
    $(this).hover(
      function() { $(this).children('.info').show(); },
      function() { $(this).children('.info').hide(); });
  });

  $('#photos .photo').addClass('ui-draggable');

});
*/
function extractID(text) {
  r = /[0-9a-f]+$/;
  if(text == "") {return ;}
  return(String(r.exec(text)[0]));
}