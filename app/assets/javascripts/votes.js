$(document).on('turbolinks:load', function () {

    $('.container').on('ajax:success', 'a.vote-action', function (e) {
        var resourceData = e.detail[0];
        var selector = '.' + resourceData.type + '-' + resourceData.id;

        $(selector + ' .vote-score').html(resourceData.score);
        $(selector + ' .vote-up-control').html(resourceData.renderedVoteUpControl);
        $(selector + ' .vote-down-control').html(resourceData.renderedVoteDownControl);
        renderFlashMessage(resourceData.message, 'success');
    })
        .on('ajax:error', function (e) {
            var resourceData = e.detail[0];

            renderFlashMessage(resourceData.message, 'danger');
        });
});
