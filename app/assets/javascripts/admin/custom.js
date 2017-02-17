function add_answer(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp('new_' + association, 'g');
  $('#answer_field').append(content.replace(regexp, new_id));
}

function remove_answer(){
  $('#answer_field').on('click', '.remove-answer', function(){
    $(this).parent().hide(100);
  });
}
