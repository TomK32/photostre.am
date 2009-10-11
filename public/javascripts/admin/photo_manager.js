var PhotoManager = {
  dragable_options: { revert: true, stack: { group: 'photos', min: 50 }},
  init: function(options) {
    this.makeDraggable(options.draggables);
    this.makeDroppable(options.droppables);
    $(options.photos).each(function(index, photo) {
        PhotoManager.linksToRemoveFromWebsites(photo);
    });
  },
  makeDraggable: function(elements) {
    $(elements).draggable(this.dragable_options);
  },
  makeDroppable: function(elements) {
    $(elements).droppable({
      hoverClass: 'hover',
      drop: function(event, ui) {
        // when dropped onto website the update the photo and it's div
        photo_id = ui.draggable.attr('id');
        var droppable_class = '';
        $.map(['album', 'website'], function(c) {
          if($(event.target).hasClass(c))
            droppable_class = c;
        })
        console.log(droppable_class);
        droppable_id = extractID(event.target.id);
        $.ajax({
          type: 'post',
          url: PhotoManager.photoPath(ui.draggable),
          data: '_method=put&photo[' + droppable_class + 's]['+droppable_id+']=1',
          success: function(html){
            alert('Photo has been added to ' + droppable_class);
          },
          error: function(html){
            alert('Photo could not be added to ' + droppable_class)
          }
        });
      }
    })
  },
  linkToRemoveFromWebsite: function (photo, website) {
    delete_tag = document.createElement('a')
    delete_tag.appendChild(document.createTextNode('x'));
    console.log(website);
    $(delete_tag).click( $.ajax({
      type: 'post',
      url: PhotoManager.photoPath(photo) + '.js',
      data: '_method=put&photo[websites]['+ extractID(website.href)+']=0',
      success: function(html){
        alert('Photo has been removed from website');
      },
      error: function(html){
        alert('Photo could not be removed from website.')
      }
    }));
    console.log(delete_tag);
    $(website).insertAfter(delete_tag);
  },
  linksToRemoveFromWebsites: function(photo) {
    $(photo).find('.websites .website a').each(function(index, website) {
      PhotoManager.linkToRemoveFromWebsite(photo, website);
    });
  },
  loadInfo: function(element) {
    parent = $(element).closest(".photo");
    parent.children(".info").load(PhotoManager.photoPath(parent) + '.js .photo *');
    parent.children(".info").show();
  },
  photoPath: function(photo) {
    if(photo.id != undefined) {
      id = photo.id;
    } else {
      id = photo.attr('id');
    }
    return('/admin/photos/' + extractID(id));
  }
}
