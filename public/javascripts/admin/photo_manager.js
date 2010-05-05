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
        if(droppable.target) { droppable = $(droppable.target).closest('.droppable')[0]; }
        for(c=0; c < $('.selectable.selected').not(ui.draggable).length; c++) {
          PhotoManager.addToWebsiteOrAlbum($('.selectable.selected')[c], droppable);
        }
        PhotoManager.addToWebsiteOrAlbum(ui.draggable, droppable);
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

  init: function(options) {
    if(options) { this.options = jQuery.merge(this.options, options); }
    this.makeDraggable(this.options.draggables);
    this.makeDroppable(this.options.droppables);

    // make the selectable
    $(this.options.draggables).addClass('selectable');
    $(this.options.draggables).live('bind', this.selectElement);

    $(window).load(this.resizePhotoMananger);
    $(window).resize(this.resizePhotoMananger);

  }
}
