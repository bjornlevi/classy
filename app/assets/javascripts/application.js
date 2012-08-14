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
$(document).ready(function() {
  //enable typeahead for tagging
  tag_typeahead();

  // click events for nav-tabs on dashboard //
  add_nav_tab_events()

  // show/hide dashboard content //
  toggle_dashboard("#dashboard_" + get_active_dashboard_id());

  //ajax for will_paginate
  ajaxPagination();

});

function tag_typeahead()
{
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
}

function add_nav_tab_events()
{
  $('a', '.nav-tabs').click( function( e ){
    $('li', '.nav-tabs').removeClass('active');
    $(this).parent().addClass('active');
    toggle_dashboard("#dashboard_" + get_active_dashboard_id());
  });
}

function get_active_dashboard_id()
{
  return $('.active', '.nav-tabs').attr("id");
}

function toggle_dashboard(dashboard_id)
{
  $(".dashboard_box").each( function( i ){
    $(this).hide()
  });
  $(dashboard_id).parent().show();
}

function ajaxPagination()
{
  $(".pagination a").live('click', function() {
    var target = $(this).parents(".dashboard_content");
    var query = '/feeds/'+get_active_dashboard_id()+$(this).attr("href")
    if($(this).attr("href").indexOf("feeds") >= 0)
      query = $(this).attr("href"); //uri fix for will_paginate
    $.ajax({
      type: "GET",
      url: query,
      success: function(data, textStatus, jqXHR){
        target.html(data);
      }
    });
    return false;
  });
}