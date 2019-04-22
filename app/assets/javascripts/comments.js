$(document).on('turbolinks:load', function () {
    $('.container').on('click', '.new-comment-link', function (e) {
        var selector = '.' + $(e.currentTarget).data('commentable') + '-comments';

        e.preventDefault();
        $(selector + ' .new-comment-link').hide();
        $(selector + ' .new-comment-form').show();
    })

    $('.container').on('ajax:success', '.new-comment-form', function (e) {
        var resourceData = e.detail[0];
        var selector = '.' + resourceData.commentable + '-comments';

        $(selector + ' .new-comment-errors').html('');
        $(JST["templates/comment"]({comment: resourceData.data})).insertBefore(selector + ' .new-comment-errors');
        //$(renderComment(resourceData.data)).insertBefore(selector + ' .new-comment-errors');
        $(selector + ' .new-comment-form textarea#comment_body').val('');
        $(selector + ' .new-comment-form').hide();
        $(selector + ' .new-comment-link').show();
        renderFlashMessage(resourceData.message, 'success');
    })
        .on('ajax:error', function (e) {
            var resourceData = e.detail[0];
            var selector = '.' + resourceData.commentable + '-comments';

            renderErrors(selector + ' .new-comment-errors', resourceData.message, resourceData.errors);
        });

});
