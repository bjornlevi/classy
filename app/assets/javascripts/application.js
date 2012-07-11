// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.flot

$(document).ready(function() {
  $('.typeahead').typeahead();
  $('#create_tag').keypress( function( e ) {
		if( e.keyCode == 13 ) {
			$.ajax({
				type: 'POST', 
				url: '/tags', 
				data: {tag: $('#create_tag').val(), post_id: $('#like_post_id').attr('value')}
			});
		}
  });

  // click events for nav-tabs on dashboard //
  $('a', '.nav-tabs').click( function( e ){
    $('li', '.nav-tabs').removeClass('active');
    $(this).parent().addClass('active');
    toggle_dashboard(get_active_dashboard_id());
  });

  // show/hide dashboard content //
  toggle_dashboard(get_active_dashboard_id());

});

function get_active_dashboard_id()
{
  return "#dashboard_" + $('.active', '.nav-tabs').attr("id");
}

function toggle_dashboard(dashboard_id)
{
  $(".dashboard_box").each( function( i ){
    $(this).hide()
  });
  $(dashboard_id).show();
}