// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function Enums() {
}
Enums.SPE_SIX_PACK = 80;
Enums.SPE_GROWLER_64_OZ = 70;
Enums.SPE_BOTTLE_750_ML = 60;
Enums.SPE_BOTTLE_22_OZ = 50;
Enums.SPE_BOTTLE_500_ML = 40;
Enums.SPE_BOTTLE_12_OZ = 30;
Enums.SPE_BOTTLE_330_ML = 20;
Enums.SPE_BOTTLE_7_OZ = 10;

Enums.WBE_CASE = 80;
Enums.WBE_METHUSELAH = 70;
Enums.WBE_JEROBOAM = 60;
Enums.WBE_MAGNUM = 50;
Enums.WBE_LITER = 40;
Enums.WBE_BOTTLE = 30;
Enums.WBE_HALF = 20;
Enums.WBE_SPLIT = 10;

Enums.FE_CASE = 90
Enums.FE_HALF_GALLON = 80
Enums.FE_BOTTLE_1500_ML = 70
Enums.FE_LITER = 60
Enums.FE_FIFTH = 50
Enums.FE_BOTTLE_500_ML = 40
Enums.FE_PINT = 30
Enums.FE_HALF_PINT = 20
Enums.FE_MINIATURE = 10

function list_to_string(li_selector, separator_char) {
	return list_to_array(li_selector).join(separator_char);
}

function list_to_array(li_selector) {
	var values = [];
	$(li_selector).each(function() {
		values.push($(this).text().trim());
		});
	return values;
}

function show_lookup_references(element) {
	name = '';
	if($(element).is('input')) {
		name = $(element).val();
	} else {
		name = $(element).text();
	}
    $.get('/lookups/references', 
		{ entity_type: $(element).attr('entity_type'),
		  lookup_type: $(element).attr('lookup_type'),
		  name: name },
        function(lookup_html) {
          $('.rightpane_lookup').html(lookup_html);
        });
}	

function get_selected_autocomplete_id(autocomplete_data, selected_label){
	for(key in autocomplete_data.suggestions){
		item = autocomplete_data.suggestions[key]
		if(selected_label == item.label){ return item.id; }
	}
	return null;
}

function form_fields(form_id){
  var $inputs = $("#" + form_id + " :input");
  var values = {};
  $inputs.each(function() {
      values[this.name] = $(this).val();
  });
  return values;
}

function calculate_spe(price_paid, price_type){
  if(isNaN(price_paid)){ return ""; }
  var price = parseFloat(price_paid);
  var type = parseInt(price_type);
  var ounces = 72;
  switch(type){
	case Enums.SPE_SIX_PACK: ounces = 72; return null;
	case Enums.SPE_GROWLER_64_OZ: ounces = 64; break;
	case Enums.SPE_BOTTLE_750_ML: ounces = 25.36; break;
	case Enums.SPE_BOTTLE_22_OZ: ounces = 22; break;
	case Enums.SPE_BOTTLE_500_ML: ounces = 16.91; break;
	case Enums.SPE_BOTTLE_12_OZ: ounces = 12; break;
	case Enums.SPE_BOTTLE_330_ML: ounces = 11.16; break;
	case Enums.SPE_BOTTLE_7_OZ: ounces = 7; break;
	default: return "";
  }
  var result = ((72 * price) / ounces);
  var rounded = Math.round(result*100)/100;
  if(isNaN(rounded)){ return ""; }
  return rounded; // "($" + rounded.toString() + " per six pack)";
}

function calculate_wbe(price_paid, price_type){
  if(isNaN(price_paid)){ return null; }
  var price = parseFloat(price_paid);
  var type = parseInt(price_type);
  var milliliters = 750;
  switch(type){
	case Enums.WBE_CASE: milliliters = 9000; break;
	case Enums.WBE_METHUSELAH: milliliters = 6000; break;
	case Enums.WBE_JEROBOAM: milliliters = 3000; break;
	case Enums.WBE_MAGNUM: milliliters = 1500; break;
	case Enums.WBE_LITER: milliliters = 1000; break;
	case Enums.WBE_BOTTLE: milliliters = 750; return null;
	case Enums.WBE_HALF: milliliters = 375; break;
	case Enums.WBE_SPLIT: milliliters = 187; break;
	default: return null;
  }
  var result = ((750 * price) / milliliters);
  var rounded = Math.round(result*100)/100;
  if(isNaN(rounded)){ return null; }
  return rounded; // "($" + rounded.toString() + " per 750ml)";
}

function calculate_fe(price_paid, price_type){
  if(isNaN(price_paid)){ return ""; }
  var price = parseFloat(price_paid);
  var type = parseInt(price_type);
  var milliliters = 750;
  switch(type){
	case Enums.FE_CASE: milliliters = 9000; break;
	case Enums.FE_HALF_GALLON: milliliters = 1750; break;
	case Enums.FE_BOTTLE_1500_ML: milliliters = 1500; break;
	case Enums.FE_LITER: milliliters = 1000; break;
	case Enums.FE_FIFTH: milliliters = 750; return null;
	case Enums.FE_BOTTLE_500_ML: milliliters = 500; break;
	case Enums.FE_PINT: milliliters = 375; break;
	case Enums.FE_HALF_PINT: milliliters = 200; break;
	case Enums.FE_MINIATURE: milliliters = 50; break;
	default: return "";
  }
  var result = ((750 * price) / milliliters);
  var rounded = Math.round(result*100)/100;
  if(isNaN(rounded)){ return ""; }
  return rounded; // "($" + rounded.toString() + " per 750ml)";
}


function toggle_product_details() {
  var details = $("#product_details");
  if(details.is(':visible')){
    $("#product_details_toggle a").text("[+]");
    details.slideUp();
    $.cookie('show_product_details', 'false');
  } else {
    $("#product_details_toggle a").text("[-]");
    details.slideDown();
    $.cookie('show_product_details', 'true');
  }
  return false;
}

function toggle_note_details() {
  var details = $("#note_details");
  if(details.is(':visible')){
    $("#note_details_toggle a").text("[+]");
    details.slideUp();
    $.cookie('show_note_details', 'false');
  } else {
    $("#note_details_toggle a").text("[-]");
    details.slideDown();
    $.cookie('show_note_details', 'true');
  }
  return false;
}

function toggle_note_detailed_description(display) {
  var details = $("#note_detailed_description");
  if(display){
    $("#note_detailed_description_on").hide();
    $("#note_detailed_description_off").show();
    $(".notes_label").text("Summary: ");
    $(".notes_summary").height("50px");
    details.slideDown();
    $.cookie('show_note_detailed_description', 'true');
  } else {
    $("#note_detailed_description_on").show();
    $("#note_detailed_description_off").hide();
    $(".notes_label").text("Notes: ");
    $(".notes_summary").height("150px");
    details.slideUp();
    $.cookie('show_note_detailed_description', 'false');
  }
  return false;
}

function format_lookup_collection_item(lookup_name, entity_type, lookup_type, name){
  html = '<li><a class="item_name lookup_link" href="#" tabindex="-1"'
  if((typeof(entity_type) != 'undefined') && (typeof(lookup_type) != 'undefined')){
    html = html + ', entity_type="' + entity_type + '", lookup_type="' + lookup_type +
      '", onclick="show_lookup_references(this); return false;"'
  }
  html = html + '>' + name +
    '<a class="remove_item" onclick="$(this).closest(\'li\').remove(); return false;" href="#" tabindex="-1">X</a>' +
    '<input type="hidden" name="' + lookup_name + '_names[]" value="' + name + '"/></li>'
  return html;
}

function add_lookup_collection_item_helper(lookup_name, entity_type, lookup_type, lookup_value){
  var regex=/[a-zA-Z]/;
  if(!regex.test(lookup_value)) {
    return false;
  }
  var exists = false;
  $("#" + lookup_name + "_row ul.form_list li a.item_name").each(function(index){
    if($(this).text().toUpperCase() == lookup_value.toUpperCase()){
      exists = true;
    }
  });
  if(!exists){
    form_list = $("#" + lookup_name + "_row ul.form_list");
    form_list.append(format_lookup_collection_item(lookup_name, entity_type, lookup_type, lookup_value));
  }
  return true;
}

function add_lookup_collection_item(lookup_name, entity_type, lookup_type){
  var lookup_value = $("#" + lookup_name + "_name").val();
  if(add_lookup_collection_item_helper(lookup_name, entity_type, lookup_type, lookup_value)) {
    $("#" + lookup_name + "_name").val('');
  }
}

function pull_autocomplete_from_previous_response(prior_term, new_term, prior_results){
  if(prior_term == null || new_term == null || prior_results == null){
	return null;
  }
  // Test whether the new term is an addition to the prior one
  if(new_term.substring(0, prior_term.length) != prior_term){
	return null;
  }
  return prior_results;
}


