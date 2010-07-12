var PhotoManager = {
  selected: [],
  current_page: 0,

  options: {draggables:'.draggable', droppables:'.droppable'},
  draggable_options: { revert: true, min: 500, helper: 'clone', appendTo: 'body', containment: 'window' },

  selectElement: function(event) {
    if(event.target) {
      $(event.target).closest('.selectable').toggleClass('selected');
      return false;
    }
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
        if(droppable.target) { var droppable = $(droppable.target).closest('.droppable')[0]; }
        $(ui.draggable).closest('.selectable').addClass('selected');
        var photo_ids = Array();
        $('.selectable.selected').map(function() {
          if(photo_ids.indexOf(photo_id = extractID($(this).attr('id'))) == -1) {
            photo_ids.push(photo_id);
          }
        });

        PhotoManager.addToWebsiteOrAlbum(photo_ids, droppable);
      }
    });
  },

  addToWebsiteOrAlbum: function(photo_ids, droppable) {
    var droppable_target = $(droppable).closest('[id!=""]')[0];
    var droppable_class = '';
    $.map(['album', 'website'], function(c) {
      if($(droppable_target).hasClass(c)) { droppable_class = c; }
    });
    var droppable_id = extractID(droppable_target.id);
    $.ajax({
      type: 'post',
      url: '/admin/related_photos.js',
      data: '_method=post&photo_ids[]=' + photo_ids.join('&photo_ids[]=') + '&' + droppable_class + '_id=' + droppable_id,
      success: function(response, textStatus, XMLHttpRequest) {
        $('.selectable.selected').removeClass('selected');
        $('.data .photos_count', $(droppable_target)).html(response);
      },
      error: function(response, textStatus, XMLHttpRequest) {
        alert('Photo could not be added to ' + droppable_class);
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
    event.preventDefault();
  },

  loadInfo: function(element) {
    var parent = $(element).closest(".photo");
    parent.children(".info").load(this.photoPath(parent) + '.js .photo *');
    parent.children(".info").show();
  },
  photoPath: function(photo) {
    var id;
    if(photo.id !== undefined) {
      id = photo.id;
    } else {
      id = photo.attr('id');
    }
    return('/admin/photos/' + extractID(id) + '.js');
  },

  resizePhotoMananger: function() {
    var width = $(window).width();
    $('.column_2_3').siblings().map(function(i, e){width = width - $(e).width(); });
    width = (width - (width % 80)) - 54;
    $('.column_2_3').css('width', Math.min(Math.max(260,width), 826), true);

    var height = $(window).height() - $('#photo_manager').offset().top - $('#filter').height() - Math.max(79, $('#photos').height());
    $('.columns').children().height(Math.max(300,height));
  },

  scrollPhotosLeft: function() {
    PhotoManager.scrollPhotos(-1);
  },
  scrollPhotosRight: function() {
    PhotoManager.scrollPhotos(1);
  },
  scrollPhotos: function(direction) {
    if(direction == 1 && $('#photos .photo:last').offset().left < $(window).width()) {
      return true; // don't scroll if the last photo is visible
    }

    var pixels = $('#photos_container').width() * direction - (20 * direction);
    var left = Math.max(0, $('#photos_container').scrollLeft() + pixels);

    $('#photos_container').scrollLeft(left);

    // check out if we gotta load moar photoz
    if($('#photos .photo:last').offset().left < $('#photos_container').width()) {
      PhotoManager.loadPhotos();
    }
  },

  loadPhotos: function(increment) {
    if(increment === undefined) { increment = 1; }
    photos_count = $('#photos .photo').size();
    if(photos_count !== 0 && photos_count < (PhotoManager.current_page * parseInt($('#photos_form #per_page').val(), 10))) {
      return true;
    }
    PhotoManager.current_page += increment;
    $('#photos_form').append('<input type="hidden" name="mode" value="append" id="mode">');
    $('#photos_form').append('<input type="hidden" name="page" value="' + PhotoManager.current_page + '" id="page">');
    $('#photos_form').callRemote();
  },

  init: function(options) {
    if(options) { this.options = jQuery.merge(this.options, options); }
    this.current_page = 1;

    this.makeDraggable(this.options.draggables);
    this.makeDroppable(this.options.droppables);
    this.makeSelectable(this.options.draggables);

    $('a', this.options.droppables).live('click', this.loadRelatedPhotos);

    this.resizePhotoMananger();
    $(window).resize(this.resizePhotoMananger);

    $('.photos_left').click(this.scrollPhotosLeft);
    $('.photos_right').click(this.scrollPhotosRight);

    $('#photos_form').bind('ajax:success', function () {
      PhotoManager.makeDraggable(PhotoManager.options.draggables);
      PhotoManager.makeSelectable(PhotoManager.options.draggables);
    });
    $('#photos_form').bind('ajax:complete', function() {
      $('#photos .please_wait').remove();
      $('#photos_form #mode').remove();
      $('#photos_form #page').remove();
      PhotoManager.resizePhotoMananger();
    });
  }
};
