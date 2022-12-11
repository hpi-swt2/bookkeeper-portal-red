   // Hover Bootstrap 5 Navbar Dropdowns
    
   $('.dropdown').mouseover(function () {
    if($('.navbar-toggler').is(':hidden')) {
        $(this).addClass('show').attr('aria-expanded', 'true');
        $(this).find('.dropdown-menu').addClass('show');
    }
}).mouseout(function () {
    if($('.navbar-toggler').is(':hidden')) {
        $(this).removeClass('show').attr('aria-expanded', 'false');
        $(this).find('.dropdown-menu').removeClass('show');
    }
});