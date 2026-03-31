# McDonnell Douglas DC-10 Fuel
# Copyright (c) 2026 Josh Davidson (Octal450)

var FUEL = {
	Controls: {
		apuStartPump: props.globals.getNode("/controls/fuel/apu-start-pump"),
		fill1: props.globals.getNode("/controls/fuel/fill-1"),
		fill2: props.globals.getNode("/controls/fuel/fill-2"),
		fill3: props.globals.getNode("/controls/fuel/fill-3"),
		pump1Aft: props.globals.getNode("/controls/fuel/pump-1-aft"),
		pump1Fwd: props.globals.getNode("/controls/fuel/pump-1-fwd"),
		pump2LAft: props.globals.getNode("/controls/fuel/pump-2l-aft"),
		pump2RAft: props.globals.getNode("/controls/fuel/pump-2r-aft"),
		pump2Fwd: props.globals.getNode("/controls/fuel/pump-2-fwd"),
		pump3Aft: props.globals.getNode("/controls/fuel/pump-3-aft"),
		pump3Fwd: props.globals.getNode("/controls/fuel/pump-3-fwd"),
		transAuxL: props.globals.getNode("/controls/fuel/trans-aux-l"),
		transAuxR: props.globals.getNode("/controls/fuel/trans-aux-r"),
		trans1: props.globals.getNode("/controls/fuel/trans-1"),
		trans2: props.globals.getNode("/controls/fuel/trans-2"),
		trans3: props.globals.getNode("/controls/fuel/trans-3"),
		xFeed1: props.globals.getNode("/controls/fuel/x-feed-1"),
		xFeed2: props.globals.getNode("/controls/fuel/x-feed-2"),
		xFeed3: props.globals.getNode("/controls/fuel/x-feed-3"),
	},
	Failures: {
		aftPump1: props.globals.getNode("/systems/failures/fuel/aft-pump-1"),
		aftPump2L: props.globals.getNode("/systems/failures/fuel/aft-pump-2l"),
		aftPump2R: props.globals.getNode("/systems/failures/fuel/aft-pump-2r"),
		aftPump3: props.globals.getNode("/systems/failures/fuel/aft-pump-3"),
		altPump: props.globals.getNode("/systems/failures/fuel/alt-pump"),
		apuStartPump: props.globals.getNode("/systems/failures/fuel/apu-start-pump"),
		fwdPump1: props.globals.getNode("/systems/failures/fuel/fwd-pump-1"),
		fwdPump2: props.globals.getNode("/systems/failures/fuel/fwd-pump-2"),
		fwdPump3: props.globals.getNode("/systems/failures/fuel/fwd-pump-3"),
		trans1: props.globals.getNode("/systems/failures/fuel/trans-1"),
		trans2: props.globals.getNode("/systems/failures/fuel/trans-2"),
		trans3: props.globals.getNode("/systems/failures/fuel/trans-3"),
		transAuxLowerL: props.globals.getNode("/systems/failures/fuel/trans-aux-lower-l"),
		transAuxLowerR: props.globals.getNode("/systems/failures/fuel/trans-aux-lower-r"),
		transAuxUpperL: props.globals.getNode("/systems/failures/fuel/trans-aux-upper-l"),
		transAuxUpperR: props.globals.getNode("/systems/failures/fuel/trans-aux-upper-r"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.apuStartPump.setBoolValue(0);
		me.Controls.fill1.setBoolValue(0);
		me.Controls.fill2.setBoolValue(0);
		me.Controls.fill3.setBoolValue(0);
		me.Controls.pump1Aft.setBoolValue(0);
		me.Controls.pump1Fwd.setBoolValue(0);
		me.Controls.pump2LAft.setBoolValue(0);
		me.Controls.pump2RAft.setBoolValue(0);
		me.Controls.pump2Fwd.setBoolValue(0);
		me.Controls.pump3Aft.setBoolValue(0);
		me.Controls.pump3Fwd.setBoolValue(0);
		me.Controls.transAuxL.setValue(0);
		me.Controls.transAuxR.setValue(0);
		me.Controls.trans1.setBoolValue(0);
		me.Controls.trans2.setBoolValue(0);
		me.Controls.trans3.setBoolValue(0);
		me.Controls.xFeed1.setBoolValue(0);
		me.Controls.xFeed2.setBoolValue(0);
		me.Controls.xFeed3.setBoolValue(0);
	},
	resetFailures: func() {
		me.Failures.aftPump1.setBoolValue(0);
		me.Failures.aftPump2L.setBoolValue(0);
		me.Failures.aftPump2R.setBoolValue(0);
		me.Failures.aftPump3.setBoolValue(0);
		me.Failures.altPump.setBoolValue(0);
		me.Failures.apuStartPump.setBoolValue(0);
		me.Failures.fwdPump1.setBoolValue(0);
		me.Failures.fwdPump2.setBoolValue(0);
		me.Failures.fwdPump3.setBoolValue(0);
		me.Failures.trans1.setBoolValue(0);
		me.Failures.trans2.setBoolValue(0);
		me.Failures.trans3.setBoolValue(0);
		me.Failures.transAuxLowerL.setBoolValue(0);
		me.Failures.transAuxLowerR.setBoolValue(0);
		me.Failures.transAuxUpperL.setBoolValue(0);
		me.Failures.transAuxUpperR.setBoolValue(0);
	},
};
