var PhotoManager = {
  selected: new Array(),
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

    height = $(window).height() - $('#photo_manager').offset().top - $('#filter').height() - $('#photos').height();
    $('.columns').children().height(Math.max(300,height));
  },

  movePhotosLeft: function() {
    PhotoManager.movePhotos(-1);
  },
  movePhotosRight: function() {
    PhotoManager.movePhotos(1);
  },
  movePhotos: function(direction) {
    pixels = $('#photos_container').width() * direction;
    new_margin = Math.min(0, parseInt($('#photos').css('margin-left')) - pixels);

    $('#photos').css('margin-left', new_margin + 'px');

    // check out if we gotta load moar photoz
    if($('#photos .photo:last').offset().left < $('#photos_container').width()) {
      $('#photos_form #page').val(parseInt($('#photos_form #page').val()) + 1);
      $('#photos_form').append('<input type="hidden" name="mode" value="append" id="mode">');
      $('#photos_form').callRemote();
      $('#photos_form #mode').remove();
    }
  },

  init: function(options) {
    if(options) { this.options = jQuery.merge(this.options, options); }
    this.makeDraggable(this.options.draggables);
    this.makeDroppable(this.options.droppables);

    // make the selectable
    $(this.options.draggables).addClass('selectable');
    $(this.options.draggables).live('click', this.selectElement);

    $('a', this.options.droppables).live('click', this.loadRelatedPhotos);

    $(window).load(this.resizePhotoMananger);
    $(window).resize(this.resizePhotoMananger);

    $('.photos_left').click(this.movePhotosLeft);
    $('.photos_right').click(this.movePhotosRight);

  }
}
