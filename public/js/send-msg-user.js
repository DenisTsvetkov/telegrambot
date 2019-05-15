$('.send-msg-user').on('click', function(e){
    e.preventDefault();
    let chatId = $(this).parents('tr').data('id');
    // alert(chatId);
    $('.modal-body #chat-id').val(chatId);
})
