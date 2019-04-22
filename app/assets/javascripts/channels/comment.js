$(document).on('turbolinks:load', function () {
    if (document.querySelector('.question') && document.querySelector('.answers')) {
        App.comments = [];
        subscribeForComments('question', gon.question_id);
        $.each(gon.answers, function (index, elem) {
            subscribeForComments('answer', elem);
        })
    } else {
        if (App.comments) {
            $.each(App.comments, function (index, elem) {
                elem.unsubscribe();
            });
        }
    }
});

function subscribeForComments(commentableType, commentableId) {
    App.comments.push(App.cable.subscriptions.create({
        channel: "CommentChannel",
        commentable_type: commentableType,
        commentable_id: commentableId
    }, {
        received: function (data) {
            if (gon.current_user !== data.comment.author_id) {
                var selector = '.' + data.comment.commentable_type.dasherize() + '-' + data.comment.commentable_id + '-comments';
                $(JST["templates/comment"]({comment: data.comment})).insertBefore(selector + ' .new-comment-errors');
            }
        }
    }));
}
