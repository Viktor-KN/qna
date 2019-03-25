$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.answer-edit-link', function(e) {
        e.preventDefault();
        var answerId = $(this).data('answerId');
        $('.answer-' + answerId + ' .answer-author-links').hide();
        $('.answer-' + answerId + ' .answer-edit-form').show();
    })
});
