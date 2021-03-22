$(document).on('turbolinks:load', (e) => {
	window.check_time_zone = function() {
		const zone = new Date().toLocaleTimeString('en-us', {timeZoneName: 'short'}).split(' ')[2];
		const zones = ['HST', 'AKST', 'PST', 'MST', 'CST', 'EST'];
		if (zones.includes(zone)) {
			$('#job_time_zone').val(zone);
		} else {
			$('#job_time_zone').val('PST');
		}
	}
})
