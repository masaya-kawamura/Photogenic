// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets

//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

/*global $*/
document.addEventListener("turbolinks:load", function() {
  $(document).ready(function (){
    $('#open-nav').on('click', function (){
      $('#nav').toggleClass('show');
    });
  });
});

document.addEventListener("turbolinks:load", function() {
  $(document).ready(function (){
    $('#tab-contents .tab[id != "tab1"]').hide();

    $('#tab-menu a').on('click', function(event) {
      $("#tab-contents .tab").hide();
      $("#tab-menu .active").removeClass("active");
      $(this).addClass("active");
      $($(this).attr("href")).show();
      event.preventDefault();
    });
  });
});

document.addEventListener("turbolinks:load", function() {
  $(document).ready(function() {
    $('.ranking-slid').slick({
        dots: true,
        autoplay: true,
        autoplaySpeed: 3000,
    });
  });
});

document.addEventListener("turbolinks:load", function() {
  $(document).ready(function() {
    $('.top-gallery-slid').slick({
        autoplay: true,
        autoplaySpeed: 2000,
        arrows: false,
    });
  });
});

document.addEventListener("turbolinks:load", function() {
  $(document).ready(function() {
    $('.top-photographers-slid').slick({
        slidesToShow: 3,
        slidesToScrol: 1,
        autoplay: true,
        autoplaySpeed: 2000,
        arrows: false,
    });
  });
});

