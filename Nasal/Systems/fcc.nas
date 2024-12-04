# McDonnell Douglas DC-10 FCC
# Copyright (c) 2024 Josh Davidson (Octal450)

var FCC = {
	fcc1Power: props.globals.getNode("/systems/fcc/fcc1-power"),
	fcc2Power: props.globals.getNode("/systems/fcc/fcc2-power"),
	Lsas: {
		leftInActive: props.globals.getNode("/systems/fcc/lsas/left-in-active"),
		leftOutActive: props.globals.getNode("/systems/fcc/lsas/left-out-active"),
		RightInActive: props.globals.getNode("/systems/fcc/lsas/right-in-active"),
		RightOutActive: props.globals.getNode("/systems/fcc/lsas/right-out-active"),
	},
	nlgWowTimer1: props.globals.getNode("/systems/fcc/nlg-timer-1/wow-timer"),
	Controls: {
		elevatorFeelKnob: props.globals.getNode("/controls/fcc/elevator-feel"),
		elevatorFeelMan: props.globals.getNode("/controls/fcc/elevator-feel-man"),
		flapLimit: props.globals.getNode("/controls/fcc/flap-limit"),
		ydLowerA: props.globals.getNode("/controls/fcc/yd-lower-a"),
		ydLowerB: props.globals.getNode("/controls/fcc/yd-lower-b"),
		ydUpperA: props.globals.getNode("/controls/fcc/yd-upper-a"),
		ydUpperB: props.globals.getNode("/controls/fcc/yd-upper-b"),
	},
	Failures: {
		elevatorFeel: props.globals.getNode("/systems/failures/fcc/elevator-feel"),
		flapLimit: props.globals.getNode("/systems/failures/fcc/flap-limit"),
		ydLowerA: props.globals.getNode("/systems/failures/fcc/yd-lower-a"),
		ydLowerB: props.globals.getNode("/systems/failures/fcc/yd-lower-b"),
		ydUpperA: props.globals.getNode("/systems/failures/fcc/yd-upper-a"),
		ydUpperB: props.globals.getNode("/systems/failures/fcc/yd-upper-b"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.elevatorFeelKnob.setValue(0);
		me.Controls.elevatorFeelMan.setBoolValue(0);
		me.Controls.flapLimit.setValue(0);
		me.Controls.ydLowerA.setBoolValue(1);
		me.Controls.ydLowerB.setBoolValue(1);
		me.Controls.ydUpperA.setBoolValue(1);
		me.Controls.ydUpperB.setBoolValue(1);	
	},
	resetFailures: func() {
		me.Failures.elevatorFeel.setBoolValue(0);
		me.Failures.flapLimit.setBoolValue(0);
		me.Failures.ydLowerA.setBoolValue(0);
		me.Failures.ydLowerB.setBoolValue(0);
		me.Failures.ydUpperA.setBoolValue(0);
		me.Failures.ydUpperB.setBoolValue(0);
	},
};
