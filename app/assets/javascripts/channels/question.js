$(document).on('turbolinks:load', function () {
    if (document.querySelector('.questions')) {
        App.question = App.cable.subscriptions.create("QuestionChannel", {
            received: function (data) {
                console.log(data);
                $('.questions ul').append(JST['templates/question']({question: data.question}));
            }
        });
    } else {
        if (App.question) {
            App.question.unsubscribe();
        }
    }
});
