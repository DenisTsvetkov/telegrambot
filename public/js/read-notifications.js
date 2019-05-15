$('.zmdi-notifications').click(function(){
    AJAX('/notifications', 'POST', {action:'read'}, function(msg){
        // console.log(msg.result);
        // if(msg.result == 'read_all_notifications'){
            // $(this).siblings('.quantity').detach();
            
            // $(this).parents('.noti__item').children('.notifi__title p').text('У вас 0 новых уведомлений');

            // $(this).parents('.noti__item').children('.notifi__item').empty();
        // }
    });
});