$(document).on('turbolinks:load', function () {
    if (document.querySelector('.answers')) {
        App.answer = App.cable.subscriptions.create({channel: "AnswerChannel", question_id: gon.question_id}, {
            received: function (data) {
                if (gon.current_user !== data.answer.author_id) {
                    $('.answers').append(JST['templates/answer']({answer: data.answer}));
                    scanForGists('.answer-' + data.answer.id);
                    subscribeForComments('answer', data.answer.id);
                }
            }
        });
    } else {
        if (App.answer) {
            App.answer.unsubscribe();
        }
    }
});
