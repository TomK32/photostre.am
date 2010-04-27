
$.remoteGallery = Object();

$.remoteGallery = function(target, elements, callback) {
  $.remoteGallery.settings = {target: target, elements: elements, callback: callback };

  // attach handler to load ajax
  $(elements).live('click', function(event){
    $.remoteGallery.loadRemote($(event.target).closest('a')[0].href);
    event.preventDefault();
  });

  // load content if there's a hash, and a target
  if(window.location.hash != '' && $(target)) {
    $.remoteGallery.loadRemote(window.location.hash.substr(1));
  }

  $.keyboard_navigation(elements, 0);

}

$.remoteGallery.loadRemote = function (url) {
  url = url.replace(/^http.*\..+?\//, '');
  url = url.replace(window.location.pathname.substr(1), '');
  $($.remoteGallery.settings.target).load(
    window.location.pathname + '/' + url + '.js', function(result) {
        window.location.hash = url.replace(/^.*\..+?\//, '');
        $.remoteGallery.settings.callback.call();
    }
  );
}
