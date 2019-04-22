$(document).on('turbolinks:load', function () {
    flashFadeOut();
    scanForGists();
});

function scanForGists(selector) {
    if (selector === undefined) {
        selector = '';
    } else {
        selector = selector + ' ';
    }

    $(selector + '.attached-link a').each(function () {
        if (/https?:\/\/gist\.github\.com\/[a-zA-Z0-9_\-]+\/\w+/.test($(this).attr('href'))) {
            appendGistContents(this);
        }
    });
}

function appendGistContents(elem) {
    var gistId = _.last($(elem).attr('href').split('/'));
    var oneGist = new Gh3.Gist({id: gistId});

    oneGist.fetchContents(function (err, res) {
        if (err) {
            return;
        }

        oneGist.eachFile(function (file) {
            var gistContents = "<div class='border p-3 mb-2'>" + file.filename + "<pre>" + file.content + "</pre></div>";
            $(gistContents).insertAfter(elem);
        });
    });
}

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

function flashFadeOut() {
    $(".flash-alert").delay(4000).addClass("in").fadeOut(3000);
}

function renderErrors(selector, message, errors) {
    var processedErrors = '';

    $.each(errors, function (index, elem) {
        processedErrors += '<li class="list-item">' + elem + '</li>'
    });

    $(selector).html(`
        <div class="row justify-content-center resource-errors">
            <div class="col col-md-6 ml-1 mr-1 alert alert-danger" role="alert">
                <h5 class="alert-heading text-center">${message}</h5>
                <hr>
                <ul class="list-group ml-4">
                    ${processedErrors}
                </ul>
            </div>
        </div>
    `);
}

String.prototype.dasherize = function() {
    return this.replace(/[A-Z]/g, function(char, index) {
        return (index !== 0 ? '-' : '') + char.toLowerCase();
    });
};
