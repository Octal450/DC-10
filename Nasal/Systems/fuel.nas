# McDonnell Douglas DC-10 Fuel System
# Copyright (c) 2024 Josh Davidson (Octal450)

var FUEL = {
	Fail: {
		pumpsAuxL: props.globals.getNode("/systems/failures/fuel/pumps-aux-l"),
		pumpsAuxR: props.globals.getNode("/systems/failures/fuel/pumps-aux-r"),
		pumps1: props.globals.getNode("/systems/failures/fuel/pumps-1"),
		pumps2: props.globals.getNode("/systems/failures/fuel/pumps-2"),
		pumps3: props.globals.getNode("/systems/failures/fuel/pumps-3"),
	},
	Switch: {
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
	init: func() {
		me.resetFailures();
		me.Switch.fill1.setBoolValue(0);
		me.Switch.fill2.setBoolValue(0);
		me.Switch.fill3.setBoolValue(0);
		me.Switch.pump1Aft.setBoolValue(0);
		me.Switch.pump1Fwd.setBoolValue(0);
		me.Switch.pump2LAft.setBoolValue(0);
		me.Switch.pump2RAft.setBoolValue(0);
		me.Switch.pump2Fwd.setBoolValue(0);
		me.Switch.pump3Aft.setBoolValue(0);
		me.Switch.pump3Fwd.setBoolValue(0);
		me.Switch.transAuxL.setValue(0);
		me.Switch.transAuxR.setValue(0);
		me.Switch.trans1.setBoolValue(0);
		me.Switch.trans2.setBoolValue(0);
		me.Switch.trans3.setBoolValue(0);
		me.Switch.xFeed1.setBoolValue(0);
		me.Switch.xFeed2.setBoolValue(0);
		me.Switch.xFeed3.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.pumpsAuxL.setBoolValue(0);
		me.Fail.pumpsAuxR.setBoolValue(0);
		me.Fail.pumps1.setBoolValue(0);
		me.Fail.pumps2.setBoolValue(0);
		me.Fail.pumps3.setBoolValue(0);
	},
};
