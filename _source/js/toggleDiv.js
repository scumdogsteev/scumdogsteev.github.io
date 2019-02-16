{
$(".bullet").click(function () {
    if ($(this).next(".detail").is(":hidden")) {
        $(this).next(".detail").toggle(750);
        $(this).children('span').text('-');
    } else {
        $(this).next(".detail").toggle(750);
        $(this).children('span').text('+');
    }
}); 
}