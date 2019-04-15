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

function flashFadeOut() {
    $(".flash-alert").delay(4000).addClass("in").fadeOut(3000);
}
