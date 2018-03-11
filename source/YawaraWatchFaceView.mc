using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class YawaraWatchFaceView extends Ui.WatchFace {

	// Colore minuti
	var COLOR_MINUTE = 0x008080;

	// Verifica se si sta visualizzado lo schermo dell'orario
	var fast_updates = true;

	// Settings
	var device_settings;

	// Status
	var device_status;

	function initialize() {
		WatchFace.initialize();
	}

	// Load your resources here
	function onLayout(dc) {
		device_settings = Sys.getDeviceSettings();
		setLayout(Rez.Layouts.WatchFace(dc));
	}

	// Called when this View is brought to the foreground. Restore
	// the state of this View and prepare it to be shown. This includes
	// loading resources into memory.
	function onShow() {
		fast_updates = true;
		Ui.requestUpdate();
	}

	// Update the view
	function onUpdate(dc) {
		System.println("update");

		//
		// Visualizza l'orario
		//
		var clockTime = Sys.getClockTime();
		var dateStrings = Time.Gregorian.info( Time.now(), Time.FORMAT_MEDIUM);
		var dateStrings_s = Time.Gregorian.info( Time.now(), Time.FORMAT_SHORT);
		var hour, min, time, day, sec, month, ampm;
		day  = dateStrings.day;
		month  = dateStrings.month;
		min  = clockTime.min;
		hour = clockTime.hour;
		sec  = clockTime.sec;
		if( !device_settings.is24Hour ) {
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
			if (hour >= 12) {
				hour = hour - 12;
				ampm = "PM";
			} else {
				ampm = "AM";
			}
			if (hour == 0) {hour = 12;}
			hour = Lang.format("$1$",[hour.format("%2d")]);
			min = Lang.format("$1$",[min.format("%02d")]);
		} else {
			hour = Lang.format("$1$",[hour.format("%02d")]);
			min = Lang.format("$1$",[min.format("%02d")]);
			ampm = "";
		}
		// Scrive ore e minuti
		var viewHour = View.findDrawableById("TimeHourLabel");
		var viewMinute = View.findDrawableById("TimeMinuteLabel");
		var viewAMPM = View.findDrawableById("TimeAMPMLabel");
		viewHour.setText(hour);
		viewMinute.setText(min);
		viewAMPM.setText(ampm);

		// Se l'utente sta guardando la schermata orologio visualizza tutte le informazioni
		if (fast_updates){
			sec = Lang.format("$1$",[sec.format("%02d")]);
			var viewSecond = View.findDrawableById("TimeSecondLabel");
			viewSecond.setText(sec);
		}
		System.println("Orario = "+hour+":"+min+"."+sec);

		//
		// Livello batteria
		//
		device_status = Sys.getSystemStats();
		var bperc = device_status.battery;
		var picBattery = Ui.loadResource(Rez.Drawables.batteryFull);
		dc.drawBitmap(120, 50, picBattery);
		System.println("Livello batteria = " + bperc);

		// Call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);
	}

	// Called when this View is removed from the screen. Save the
	// state of this View here. This includes freeing resources from
	// memory.
	function onHide() {
		fast_updates = false;
		Ui.requestUpdate();
	}

	// The user has just looked at their watch. Timers and animations may be started here.
	function onExitSleep() {
	}

	// Terminate any active timers and prepare for slow updates.
	function onEnterSleep() {
	}
}
