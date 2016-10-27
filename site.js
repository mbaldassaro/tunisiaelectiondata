---
---
{% include ext/jquery.min.js %}

$(function() {
    var todp = {};
    window.todp = todp;
    $.fn.digits = function(){
        return this.each(function(){
            $(this).text( $(this).text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") );
        });
    }

    var $dropdown = $('.dropdown-menu');
    $dropdown.each(function(i, el) {
        $(this).hover(function() {
            $(this).addClass('open');
        }, function(e) {
            $(this).removeClass('open');
        });
    });

    $('.dropdown-hover').click(function() {
        return false;
    });
    $('.downcontrols a').click(function(e){
    e.preventDefault();
    var content = $(this).attr('rel');
    var contentToHide=$('.active').attr('rel');
    $('.active').removeClass('active');
    $(this).addClass('active');
    $('#'+contentToHide).hide();
    $('#'+content).show();
});
});

