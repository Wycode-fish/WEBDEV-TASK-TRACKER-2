// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import $ from "jquery";

function update_button() {
	$('.slot-button').each( (_, bb) => {
		if ($(bb).data('start-time') > 0) {
			$(bb).text("take a break.");
		}
		else {
			$(bb).text("start to work");
		}
	});
}

function set_button(t) {
	$('.slot-button').each( (_, bb) => {
		$(bb).data('start-time', t);
	});
	update_button();
}


function end_slot() {
	let stime = $('.slot-button:first').data('start-time');
	console.log("----------------"+stime);
	let text = JSON.stringify ({
		slot: {
			task_id: current_task_id,
			start_time: stime,
			end_time: Math.round(new Date().getTime()/1000),
		}
	});
	$.ajax(slot_path, {
	    method: "post",
	    dataType: "json",
	    contentType: "application/json; charset=UTF-8",
	    data: text,
	    success: (resp) => { set_button(-1); },
	});
}

function start_slot() {
	$('.slot-button').each( (_, bb) => {
		$(bb).data('start-time', Math.round(new Date().getTime()/1000));
	});
	update_button();
}

function slot_click(e) {
	let btn = $(e.target);
	let stime = btn.data('start-time');

	if (stime > 0) {
		end_slot();
	}
	else {
		start_slot();
	}
}

function init_slot() {
	if (!$('.slot-button')) return;

	$(".slot-button").click(slot_click);
	set_button(-1);

	update_button();
}

$(init_slot);