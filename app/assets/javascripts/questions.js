$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.question-edit-link', function(e) {
        e.preventDefault();
        $('.question .question-author-links').hide();
        $('.question .question-edit-form').show();
    });

    $('#reward').on('click', '.question-add-reward-link', function(e) {
        e.preventDefault();
        $('.reward-fields').show();
        $('.question-add-reward-link').hide();
    });

    var $rewardTitle = $('input#question_reward_attributes_title');

    if ($rewardTitle.length !== 0 && $rewardTitle[0].value !== '') {
        $('.reward-fields').show();
        $('.question-add-reward-link').hide();
    }
});
