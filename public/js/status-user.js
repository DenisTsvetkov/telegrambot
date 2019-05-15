$('.switch-label, .switch-handle').on('click', function() {
    let chatUserId = parseInt($(this).parents('tr').data('id'));
    if ($(this).parents('.switch').children('.switch-input').is(':checked')) {
        // Чекбок включен
        
        AJAX('/change-status', 'POST', {chat_id: chatUserId, new_status:false})
    }
    else{
        // Чекбок выключен
        AJAX('/change-status', 'POST', {chat_id: chatUserId, new_status:true})
    }
});