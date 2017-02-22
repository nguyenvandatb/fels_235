$(document).on('click','#tab #check_all',function(e){
  if ($('#tab #check_all').is(':checked')) {
    $('#tab input[type=checkbox]').each(function () {
      $(this).prop('checked', true);
    });
  } else {
    $('#tab input[type=checkbox]').each(function () {
      $(this).prop('checked', false);
    });
  }
});
$(document).on('click','#delete_all',function(e){
  e.preventDefault();
  word_ids = $('input:checked').map(function(){
    return $(this).val();
  });
  confirm_msg = I18n.t('confirm');
  var ids = word_ids.get();
  console.log(ids);
  if (word_ids.get().length > 0 && confirm(confirm_msg)){
    $.ajax({
      type: 'delete',
      dataType: 'json',
      url: '/admin/words',
      data: {id: ids},
      success: function(data){
        if(data.status == "OK"){
          var not_destroy = data.total_destroy;
          for(i in not_destroy){
            $('#tab_body').find('td[value='+not_destroy[i]+']').parents('tr').remove();
          }
          if (data.total_destroy.length > 0) {
            $('#notify-message').addClass('alert alert-success')
              .text(I18n.t('delete_success')+':'+data.total_destroy)
                .delay(5000).fadeOut('slow');
          }
          if(data.total_not_destroy.length > 0){
            $('#notify-message-fails').addClass('alert alert-danger')
              .text(I18n.t('delete_fails')+':'+data.total_not_destroy)
                .delay(5000).fadeOut('slow');
          }
        }else {
          $('#notify-message').addClass('alert alert-danger').text(I18n.t('delete_fails'));
        }
      },
      error: function(data){
        $('#notify-message').addClass('alert alert-danger').text(I18n.t('delete_fails'));
      }
    });
  }else{
    alert(I18n.t('not_null_ids'));
  }
});
