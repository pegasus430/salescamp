// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require modernizr
//= require jquery.minicolors
//= require webflow
//= require smart_listing
//= require cocoon
//= require clipboard
//= require toastr
//= require almond
//= require_tree ./main

$(function() {
    $('.flash-container').fadeIn();
    $('.flash').click(function() {
        $(this).fadeOut(100, function() {
            $(this).css("visibility", "hidden");
        });
    }).hover(function() {
        $(this).fadeTo(400, 0.5);
    }, function() {
        $(this).fadeTo(400, 1);
    });
});


$(document).ready(function(){
    $(".pending_users").click(function(){
        $(".pending_users_list").show();
        $(".fullfilled_users_list").hide();
        $(".campaign_info_list").hide();
    });
    
    $(".campaign_info").click(function(){
        $(".pending_users_list").hide();
        $(".fullfilled_users_list").hide();
        $(".campaign_info_list").show();
    });

    $(".fullfilled_users_info").click(function(){
        $(".pending_users_list").hide();
        $(".fullfilled_users_list").show();
        $(".campaign_info_list").hide();
    });
   
   $(".view-link").click(function(){
        $(".pending_users_list").show();
        $(".fullfilled_users_list").hide();
        $(".campaign_info_list").hide();
    });
  
   $('.pagination > a').attr('data-remote', 'true');

});