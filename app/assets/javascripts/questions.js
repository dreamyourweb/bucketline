function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
	var start_date_3i = $("#project_start_at_3i").val();
	var start_date_2i = $("#project_start_at_2i").val();
	var start_date_1i = $("#project_start_at_1i").val();
	var end_date_3i = $("#project_end_at_3i").val();
	var end_date_2i = $("#project_end_at_2i").val();
	var end_date_1i = $("#project_end_at_1i").val();
	var daypart = $("#project_daypart").val();

  var regexp = new RegExp("new_" + association, "g");
  $(link).before(content.replace(regexp, new_id));

	$(".item_daypart").val(daypart);

	$(".item_date_start").last().children(":first").val(start_date_3i);
	$(".item_date_start").last().children(":first").next().val(start_date_2i);
	$(".item_date_start").last().children(":first").next().next().val(start_date_1i);

	$(".item_date_end").last().children(":first").val(end_date_3i);
	$(".item_date_end").last().children(":first").next().val(end_date_2i);
	$(".item_date_end").last().children(":first").next().next().val(end_date_1i);
}
