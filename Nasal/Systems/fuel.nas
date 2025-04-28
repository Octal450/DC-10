# McDonnell Douglas DC-10 Fuel System
# Copyright (c) 2025 Josh Davidson (Octal450)

var FUEL = {
	Controls: {
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
		pumpsAuxL: props.globals.getNode("/systems/failures/fuel/pumps-aux-l"),
		pumpsAuxR: props.globals.getNode("/systems/failures/fuel/pumps-aux-r"),
		pumps1: props.globals.getNode("/systems/failures/fuel/pumps-1"),
		pumps2: props.globals.getNode("/systems/failures/fuel/pumps-2"),
		pumps3: props.globals.getNode("/systems/failures/fuel/pumps-3"),
	},
	init: func() {
		me.resetFailures();
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
		me.Failures.pumpsAuxL.setBoolValue(0);
		me.Failures.pumpsAuxR.setBoolValue(0);
		me.Failures.pumps1.setBoolValue(0);
		me.Failures.pumps2.setBoolValue(0);
		me.Failures.pumps3.setBoolValue(0);
	},
};
