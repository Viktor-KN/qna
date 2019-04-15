$(document).on('turbolinks:load', function() {

    $('.vote').on('ajax:success', 'a.vote-action', function(e) {
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

function renderFlashMessage(message, role) {
    $('.flash-messages').html(`
        <div class="row justify-content-center">
            <div class="col col-md-4 alert flash-alert alert-${role} alert-dismissible fade show in" role="alert">
                ${message}
                <button aria-label="Close" class="close" data-dismiss="alert" type="button">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
        </div>
        `);
    flashFadeOut();
}
