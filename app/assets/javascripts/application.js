   // Hover Bootstrap 5 Navbar Dropdowns
   // pasted from https://wpforthewin.com/how-to-get-hover-dropdowns-in-bootstrap-5-navbars/
    
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