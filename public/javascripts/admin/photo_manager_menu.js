var PhotoManagerMenu = {
  showMenuItem: function(element) {
    $('> .title a', element).trigger('click');
    $(element).closest('.menu').children('.menu_item').hide(); // hides all sibs with a menuItem
    $(element).closest('.menu').show();
    $(element).closest('.menu').children('.menu_selector').hide();
    $('.menu > .menu_item:first', element).show();
    $(element).show();
  },
  showMenuSelector: function(event) {
    $(event.target).closest('.menu').children('.menu_selector').show();
    $(event.target).closest('.menu_item').hide();
    event.preventDefault();
  },
  initMenu: function(parent, menu_items, menu_id) {
    $('> .menu_item:first', parent).before('<ul class="menu_selector" id="' + menu_id + '"></ul>');
    $(menu_items, parent).map(function(){
      $('#' + menu_id).append('<li><a href="javascript:PhotoManagerMenu.showMenuItem($(\'#' + $(this).closest('[id!=""]').attr('id') + '\'));">' + $(this).text() + '</a></li>');
    });
    $('#' + menu_id).hide();
    $(menu_items, parent).live('hover', PhotoManagerMenu.showMenuSelector);
  },
  init: function(options) {
    $('#websites').addClass('menu');
    $('#websites .website').addClass('menu_item');
    PhotoManagerMenu.initMenu($('#websites'), '.website > .title', 'website_selector');

    $('#websites .albums').addClass('menu');
    $('#websites .albums .album').addClass('menu_item');
    $('#websites .albums').map(function(){
      parent_id = $(this).closest('[id!=""]').attr('id')
      parent = parent_id + ' > .menu';
      PhotoManagerMenu.initMenu('#' + parent, '.album > .title', parent_id + '_album_selector');
    });

    $('.menu > .menu_item').hide();
    $('.menu .menu_item:first, .menu .menu_item:first .menu .menu_item:first').show();
  }
}
