$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.question-edit-link', function(e) {
        e.preventDefault();
        $('.question .question-author-links').hide();
        $('.question .question-edit-form').show();
    })
});
