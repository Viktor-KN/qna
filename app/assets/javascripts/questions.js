$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.question-edit-link', function(e) {
        e.preventDefault();
        $('.question-author-links').hide();
        $('.question-edit-form').show();
    })
});
