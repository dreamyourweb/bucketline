$(function()
{
    $(".toggle").click(function() 
    {  
        // hides children divs if shown, shows if hidden 
        $(this).prev().toggle(300);
				var arrow = $(this).find(".arrow");
				if(arrow.hasClass("icon-chevron-down")) {
					arrow.removeClass("icon-chevron-down");
					arrow.addClass("icon-chevron-up");
				} else {
					arrow.removeClass("icon-chevron-up");
					arrow.addClass("icon-chevron-down");
				};
    }); 
});
