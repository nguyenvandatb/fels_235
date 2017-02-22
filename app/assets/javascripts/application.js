// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require bootstrap.min.js
//= require turbolinks
//= require_tree .
$(document).on('turbolinks:load', function(){
  $('[data-toggle="tooltip"]').tooltip();
  $('#category_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/Settings.in_megabyte_number/
      Settings.in_megabyte_number;
    if (size_in_megabytes > Settings.max_image_size) {
      alert(I18n.t("image_size_message"));
    }
  });

  $('.question').first().show();

  $('.next').click(function() {
    $q = $('.question:visible');
    $q.hide();
    $q.nextAll('.question:first').show();
    if($q.nextAll('.question:first').is($('.question').last()))
    {
      $(this).attr("disabled", true);
      $('.submit_test').show();
    }
    number_question = $q.prevAll('.question').length + 2;
    width = number_question * 100.0 / $('.lesson_progress_bar').attr('aria-valuemax');
    $('.prev').attr("disabled", false);
    $('.current_question_count').text(number_question);
    $('.lesson_progress_bar').css('width', width  + '%')
      .attr('aria-valuenow', number_question);
  });

  $('.prev').click(function() {
    $q = $('.question:visible');
    $q.hide();
    $q.prevAll('.question:first').show();
    if($q.prevAll('.question:first').is($('.question').first()))
    {
      $(this).attr("disabled", true);
    }
    number_question = $q.prevAll('.question').length;
    width = number_question * 100.0 / $('.lesson_progress_bar').attr('aria-valuemax');
    $('.next').attr("disabled", false);
    $('.submit_test').hide();
    $('.current_question_count').text(number_question);
    $('.lesson_progress_bar').css('width', width +'%')
      .attr('aria-valuenow', number_question);
  });
});
$(document).on('click','#side-menu li',function(e){
  if(!$('#side-menu li ul').hasClass('in')){
    $('#side-menu li ul').eq($(this).index()-1).addClass('in');
  }else {
    $('#side-menu li ul').eq($(this).index()-1).removeClass('in');
  }
});

