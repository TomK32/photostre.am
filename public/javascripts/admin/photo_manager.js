var PhotoManager = {
  selected: new Array(),
  current_page: 0,

  options: {draggables:'.draggable', droppables:'.droppable'},
  draggable_options: { revert: true, stack: { group: 'photos'}, min: 500, helper: 'clone', appendTo: 'body', containment: 'window' },

  selectElement: function(element) {
    if(element.target) { element = $(element.target).closest('.selectable'); }
    element.toggleClass('selected');
  },

  makeDraggable: function(elements) {
    $(elements).draggable(this.draggable_options);
  },

  makeSortable: function(elements) {
    $(elements).sortable(this.sortable_options);
  },
  makeSelectable: function(elements) {
    $(elements).addClass('selectable');
    $(elements).live('click', this.selectElement);
  },

  makeDroppable: function(elements) {
    $(elements).droppable({
      hoverClass: 'hover',
      drop: function(droppable, ui) {
        // TODO Refactor to retrieve an array of the ids, unique them and then send
        // them all at once.
        if(droppable.target) { droppable = $(droppable.target).closest('.droppable')[0]; }
        $(ui.draggable).addClass('selected');
        for(c=0; c < $('.selectable.selected').length; c++) {
          PhotoManager.addToWebsiteOrAlbum($('.selectable.selected')[c], droppable);
        }
      }
    });
  },

  addToWebsiteOrAlbum: function(photo, droppable) {
    photo_id = extractID($(photo).attr('id'));
    var droppable_class = '';
    $.map(['album', 'website'], function(c) {
      if($(droppable).hasClass(c))
        droppable_class = c;
    });
    droppable_id = extractID(droppable.id);
    $.ajax({
      type: 'post',
      url: '/admin/related_photos.js',
      data: '_method=post&related_photo[photo_id]=' + photo_id + '&' + droppable_class + '_id=' + droppable_id,
      success: function(html){
        $(photo).removeClass('selected');
        $('.count', droppable).html(html);
      },
      error: function(html){
        alert('Photo could not be added to ' + droppable_class)
      }
    });
  },

  // Accounts only for dropping on an album
  makeDroppableKeyPhoto: function(elements) {
    $(elements.droppable({
      hoverClass: 'hover',
      drop: function(event,ui) {

      }
    }));
  },

  loadRelatedPhotos: function(event) {
    $(PhotoManager.options.droppables).removeClass('current');
    $(event.target).closest(PhotoManager.options.droppables).addClass('current');
    //event.preventDefault();
  },

  loadInfo: function(element) {
    parent = $(element).closest(".photo");
    parent.children(".info").load(this.photoPath(parent) + '.js .photo *');
    parent.children(".info").show();
  },
  photoPath: function(photo) {
    if(photo.id != undefined) {
      id = photo.id;
    } else {
      id = photo.attr('id');
    }
    return('/admin/photos/' + extractID(id) + '.js');
  },

  resizePhotoMananger: function() {
    width = $(window).width();
    $('.column_2_3').siblings().map(function(i, e){width = width - $(e).width()});
    width = (width - (width % 80)) - 54;
    $('.column_2_3').css('width', Math.min(Math.max(400,width), 826), true);

    height = $(window).height() - $('#photo_manager').offset().top - $('#filter').height() - Math.max(80, $('#photos').height());
    $('.columns').children().height(Math.max(300,height));
  },

  scrollPhotosLeft: function() {
    PhotoManager.scrollPhotos(-1);
  },
  scrollPhotosRight: function() {
    PhotoManager.scrollPhotos(1);
  },
  scrollPhotos: function(direction) {
    pixels = $('#photos_container').width() * direction - (20 * direction);
    new_margin = Math.min(0, parseInt($('#photos').css('margin-left')) - pixels);

    $('#photos').css('margin-left', new_margin + 'px');

    // check out if we gotta load moar photoz
    if($('#photos .photo:last').offset().left < $('#photos_container').width()) {
      PhotoManager.loadPhotos();
    }
  },

  loadPhotos: function(increment) {
    photos_count = $('#photos .photo').size();
    if($('#photos .photo').size() != 00 && photos_count < PhotoManager.current_page * parseInt($('#photos_form #per_page').val())) {
      return true;
    }
    PhotoManager.current_page += 1;
    if(increment == undefined) { increment = 1 };
    $('#photos_form').append('<input type="hidden" name="mode" value="append" id="mode">');
    $('#photos_form').append('<input type="hidden" name="page" value="' + PhotoManager.current_page + '" id="page">');
    $('#photos_form').callRemote();
    $('#photos_form').bind('ajax:complete', function() {
      $('#photos .please_wait').remove();
      $('#photos_form #mode').remove();
      $('#photos_form #page').remove();
      PhotoManager.resizePhotoMananger();
      // we've reached the end!
      if($('#photos .photo').size() < (photos_count + parseInt($('#photos_form #per_page').val()))) {
        $('#filter .photos_right').html($('#filter .photos_right').text());
      }
    });
  },

  init: function(options) {
    if(options) { this.options = jQuery.merge(this.options, options); }
    this.current_page = 0;

    this.makeDraggable(this.options.draggables);
    this.makeDroppable(this.options.droppables);
    this.makeSelectable(this.options.draggables);

    $('a', this.options.droppables).live('click', this.loadRelatedPhotos);

    this.resizePhotoMananger();
    $(window).resize(this.resizePhotoMananger);

    $('.photos_left').click(this.scrollPhotosLeft);
    $('.photos_right').click(this.scrollPhotosRight);
    this.loadPhotos(0);

    $('#photos_form').live('ajax:success', function () {
      PhotoManager.makeDraggable(PhotoManager.options.draggables);
      PhotoManager.makeSelectable(PhotoManager.options.draggables);
    });
  }
}
