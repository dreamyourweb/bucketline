$(function()
{
    $(".toggle").click(function() 
    {  
        // hides children divs if shown, shows if hidden 
        $(this).prev().toggle(300); 
    }); 
});
