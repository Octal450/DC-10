# McDonnell Douglas DC-10 Misc Systems
# Copyright (c) 2024 Josh Davidson (Octal450)

# APU
var APU = {
	egt: props.globals.getNode("/engines/engine[3]/egt-actual"),
	ff: props.globals.getNode("/engines/engine[3]/ff-actual"),
	n1: props.globals.getNode("/engines/engine[3]/n1-actual"),
	n2: props.globals.getNode("/engines/engine[3]/n2-actual"),
	state: props.globals.getNode("/engines/engine[3]/state"),
	Switch: {
		master: props.globals.getNode("/controls/apu/switches/master"),
	},
	init: func() {
		me.Switch.master.setValue(0);
	},
	fastStart: func() {
		me.Switch.master.setValue(1);
		settimer(func() { # Give the fuel system a moment to provide fuel in the pipe
			pts.Fdm.JSBSim.Propulsion.setRunning.setValue(3);
		}, 1);
	},
	stopRpm: func() {
		settimer(func() { # Required delay
			if (me.n2.getValue() >= 1) {
				pts.Fdm.JSBSim.Propulsion.Engine.n1[3].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.Engine.n2[3].setValue(0.1);
			}
		}, 0.1);
	},
};

# Engine Control
var ENGINE = {
	cutoffSwitch: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[2]/cutoff-switch")],
	manEpr: [props.globals.getNode("/controls/engines/engine[0]/man-epr"), props.globals.getNode("/controls/engines/engine[1]/man-epr"), props.globals.getNode("/controls/engines/engine[2]/man-epr")],
	manEprSet: [props.globals.getNode("/controls/engines/engine[0]/man-epr-set"), props.globals.getNode("/controls/engines/engine[1]/man-epr-set"), props.globals.getNode("/controls/engines/engine[2]/man-epr-set")],
	manN1: [props.globals.getNode("/controls/engines/engine[0]/man-n1"), props.globals.getNode("/controls/engines/engine[1]/man-n1"), props.globals.getNode("/controls/engines/engine[2]/man-n1")],
	manN1Set: [props.globals.getNode("/controls/engines/engine[0]/man-n1-set"), props.globals.getNode("/controls/engines/engine[1]/man-n1-set"), props.globals.getNode("/controls/engines/engine[2]/man-n1-set")],
	n1Temp: 0,
	reverseEngage: [props.globals.getNode("/controls/engines/engine[0]/reverse-engage"), props.globals.getNode("/controls/engines/engine[1]/reverse-engage"), props.globals.getNode("/controls/engines/engine[2]/reverse-engage")],
	startCmd: [props.globals.getNode("/controls/engines/engine[0]/start-cmd"), props.globals.getNode("/controls/engines/engine[1]/start-cmd"), props.globals.getNode("/controls/engines/engine[2]/start-cmd")],
	startSwitch: [props.globals.getNode("/controls/engines/engine[0]/start-switch"), props.globals.getNode("/controls/engines/engine[1]/start-switch"), props.globals.getNode("/controls/engines/engine[2]/start-switch")],
	throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle"), props.globals.getNode("/controls/engines/engine[2]/throttle")],
	throttleTemp: [0, 0, 0],
	init: func() {
		me.manEpr[0].setValue(1.5);
		me.manEpr[1].setValue(1.5);
		me.manEpr[2].setValue(1.5);
		me.manEprSet[0].setBoolValue(0);
		me.manEprSet[1].setBoolValue(0);
		me.manEprSet[2].setBoolValue(0);
		me.manN1[0].setValue(110);
		me.manN1[1].setValue(110);
		me.manN1[2].setValue(110);
		me.manN1Set[0].setBoolValue(0);
		me.manN1Set[1].setBoolValue(0);
		me.manN1Set[2].setBoolValue(0);
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.reverseEngage[2].setBoolValue(0);
		me.startCmd[0].setBoolValue(0);
		me.startCmd[1].setBoolValue(0);
		me.startCmd[2].setBoolValue(0);
		me.startSwitch[0].setBoolValue(0);
		me.startSwitch[1].setBoolValue(0);
		me.startSwitch[2].setBoolValue(0);
	},
	adjustManEpr: func(n, d) {
		if (me.manEprSet[n].getBoolValue() and pts.Instrumentation.Epr.powerAvail[n].getBoolValue()) {
			me.eprTemp = math.round(me.manEpr[n].getValue() + (d * 0.01), (abs(d * 0.01))); # Kill floating point error
			if (me.eprTemp < 1) {
				me.manEpr[n].setValue(1);
			} else if (me.eprTemp > 2.0) {
				me.manEpr[n].setValue(2.0);
			} else {
				me.manEpr[n].setValue(me.eprTemp);
			}
		}
	},
	adjustManN1: func(n, d) {
		if (me.manN1Set[n].getBoolValue() and pts.Instrumentation.N.powerAvail[n].getBoolValue()) {
			me.n1Temp = math.round(me.manN1[n].getValue() + (d * 0.1), (abs(d * 0.1))); # Kill floating point error
			if (me.n1Temp < 0) {
				me.manN1[n].setValue(0);
			} else if (me.n1Temp > 120) {
				me.manN1[n].setValue(120);
			} else {
				me.manN1[n].setValue(me.n1Temp);
			}
		}
	},
};

# Base off Engine 2
var doRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		ENGINE.throttleTemp[1] = ENGINE.throttle[1].getValue();
		if (!ENGINE.reverseEngage[0].getBoolValue() or !ENGINE.reverseEngage[1].getBoolValue() or !ENGINE.reverseEngage[2].getBoolValue()) {
			ENGINE.reverseEngage[0].setBoolValue(1);
			ENGINE.reverseEngage[1].setBoolValue(1);
			ENGINE.reverseEngage[2].setBoolValue(1);
			ENGINE.throttle[0].setValue(0);
			ENGINE.throttle[1].setValue(0);
			ENGINE.throttle[2].setValue(0);
		} else if (ENGINE.throttleTemp[1] < 0.4) {
			ENGINE.throttle[0].setValue(0.4);
			ENGINE.throttle[1].setValue(0.4);
			ENGINE.throttle[2].setValue(0.4);
		} else if (ENGINE.throttleTemp[1] < 0.7) {
			ENGINE.throttle[0].setValue(0.7);
			ENGINE.throttle[1].setValue(0.7);
			ENGINE.throttle[2].setValue(0.7);
		} else if (ENGINE.throttleTemp[1] < 1) {
			ENGINE.throttle[0].setValue(1);
			ENGINE.throttle[1].setValue(1);
			ENGINE.throttle[2].setValue(1);
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.throttle[2].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
		ENGINE.reverseEngage[2].setBoolValue(0);
	}
}

var unRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINE.reverseEngage[0].getBoolValue() or ENGINE.reverseEngage[1].getBoolValue() or ENGINE.reverseEngage[2].getBoolValue()) {
			ENGINE.throttleTemp[1] = ENGINE.throttle[1].getValue();
			if (ENGINE.throttleTemp[1] > 0.7) {
				ENGINE.throttle[0].setValue(0.7);
				ENGINE.throttle[1].setValue(0.7);
				ENGINE.throttle[2].setValue(0.7);
			} else if (ENGINE.throttleTemp[1] > 0.4) {
				ENGINE.throttle[0].setValue(0.4);
				ENGINE.throttle[1].setValue(0.4);
				ENGINE.throttle[2].setValue(0.4);
			} else if (ENGINE.throttleTemp[1] > 0.05) {
				ENGINE.throttle[0].setValue(0);
				ENGINE.throttle[1].setValue(0);
				ENGINE.throttle[2].setValue(0);
			} else {
				ENGINE.throttle[0].setValue(0);
				ENGINE.throttle[1].setValue(0);
				ENGINE.throttle[2].setValue(0);
				ENGINE.reverseEngage[0].setBoolValue(0);
				ENGINE.reverseEngage[1].setBoolValue(0);
				ENGINE.reverseEngage[2].setBoolValue(0);
			}
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.throttle[2].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
		ENGINE.reverseEngage[2].setBoolValue(0);
	}
}

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINE.reverseEngage[0].getBoolValue() or ENGINE.reverseEngage[1].getBoolValue() or ENGINE.reverseEngage[2].getBoolValue()) {
			ENGINE.throttle[0].setValue(0);
			ENGINE.throttle[1].setValue(0);
			ENGINE.throttle[2].setValue(0);
			ENGINE.reverseEngage[0].setBoolValue(0);
			ENGINE.reverseEngage[1].setBoolValue(0);
			ENGINE.reverseEngage[2].setBoolValue(0);
		} else {
			ENGINE.reverseEngage[0].setBoolValue(1);
			ENGINE.reverseEngage[1].setBoolValue(1);
			ENGINE.reverseEngage[2].setBoolValue(1);
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.throttle[2].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
		ENGINE.reverseEngage[2].setBoolValue(0);
	}
}

var doIdleThrust = func() {
	ENGINE.throttle[0].setValue(0);
	ENGINE.throttle[1].setValue(0);
	ENGINE.throttle[2].setValue(0);
}

var doLimitThrust = func() {
	var active = THRLIM.Limit.activeNorm.getValue();
	ENGINE.throttle[0].setValue(active);
	ENGINE.throttle[1].setValue(active);
	ENGINE.throttle[2].setValue(active);
}

var doFullThrust = func() {
	var highest = THRLIM.Limit.highestNorm.getValue();
	ENGINE.throttle[0].setValue(highest);
	ENGINE.throttle[1].setValue(highest);
	ENGINE.throttle[2].setValue(highest);
}

# Flight Control Computers
var FCC = {
	Fail: {
		elevatorFeel: props.globals.getNode("/systems/failures/fcc/elevator-feel"),
		flapLimit: props.globals.getNode("/systems/failures/fcc/flap-limit"),
		ydLowerA: props.globals.getNode("/systems/failures/fcc/yd-lower-a"),
		ydLowerB: props.globals.getNode("/systems/failures/fcc/yd-lower-b"),
		ydUpperA: props.globals.getNode("/systems/failures/fcc/yd-upper-a"),
		ydUpperB: props.globals.getNode("/systems/failures/fcc/yd-upper-b"),
	},
	fcc1Power: props.globals.getNode("/fdm/jsbsim/fcc/fcc1-power"),
	fcc2Power: props.globals.getNode("/fdm/jsbsim/fcc/fcc2-power"),
	Lsas: {
		leftInActive: props.globals.getNode("/fdm/jsbsim/fcc/lsas/left-in-active"),
		leftOutActive: props.globals.getNode("/fdm/jsbsim/fcc/lsas/left-out-active"),
		RightInActive: props.globals.getNode("/fdm/jsbsim/fcc/lsas/right-in-active"),
		RightOutActive: props.globals.getNode("/fdm/jsbsim/fcc/lsas/right-out-active"),
	},
	Switch: {
		elevatorFeelKnob: props.globals.getNode("/controls/fcc/switches/elevator-feel"),
		elevatorFeelMan: props.globals.getNode("/controls/fcc/switches/elevator-feel-man"),
		flapLimit: props.globals.getNode("/controls/fcc/switches/flap-limit"),
		ydLowerA: props.globals.getNode("/controls/fcc/switches/yd-lower-a"),
		ydLowerB: props.globals.getNode("/controls/fcc/switches/yd-lower-b"),
		ydUpperA: props.globals.getNode("/controls/fcc/switches/yd-upper-a"),
		ydUpperB: props.globals.getNode("/controls/fcc/switches/yd-upper-b"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.elevatorFeelKnob.setValue(0);
		me.Switch.elevatorFeelMan.setBoolValue(0);
		me.Switch.flapLimit.setValue(0);
		me.Switch.ydLowerA.setBoolValue(1);
		me.Switch.ydLowerB.setBoolValue(1);
		me.Switch.ydUpperA.setBoolValue(1);
		me.Switch.ydUpperB.setBoolValue(1);	
	},
	resetFailures: func() {
		me.Fail.elevatorFeel.setBoolValue(0);
		me.Fail.flapLimit.setBoolValue(0);
		me.Fail.ydLowerA.setBoolValue(0);
		me.Fail.ydLowerB.setBoolValue(0);
		me.Fail.ydUpperA.setBoolValue(0);
		me.Fail.ydUpperB.setBoolValue(0);
	},
};

# Landing Gear
var GEAR = {
	Fail: {
		centerActuator: props.globals.getNode("/systems/failures/gear/center-actuator"),
		leftActuator: props.globals.getNode("/systems/failures/gear/left-actuator"),
		noseActuator: props.globals.getNode("/systems/failures/gear/nose-actuator"),
		rightActuator: props.globals.getNode("/systems/failures/gear/right-actuator"),
	},
	Switch: {
		brakeLeft: props.globals.getNode("/controls/gear/brake-left"),
		brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		brakeRight: props.globals.getNode("/controls/gear/brake-right"),
		centerGearUp: props.globals.getNode("/controls/gear/center-gear-up"),
		lever: props.globals.getNode("/controls/gear/lever"),
		leverCockpit: props.globals.getNode("/controls/gear/lever-cockpit"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.brakeParking.setBoolValue(0);
		me.Switch.centerGearUp.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.centerActuator.setBoolValue(0);
		me.Fail.leftActuator.setBoolValue(0);
		me.Fail.noseActuator.setBoolValue(0);
		me.Fail.rightActuator.setBoolValue(0);
	},
};

# Ignition
var IGNITION = {
	cutoff1: props.globals.getNode("/systems/ignition/cutoff-1"),
	cutoff2: props.globals.getNode("/systems/ignition/cutoff-2"),
	cutoff3: props.globals.getNode("/systems/ignition/cutoff-3"),
	ignAvail: props.globals.getNode("/systems/ignition/ign-avail"),
	ign1: props.globals.getNode("/systems/ignition/ign-1"),
	ign2: props.globals.getNode("/systems/ignition/ign-2"),
	ign3: props.globals.getNode("/systems/ignition/ign-3"),
	starter1: props.globals.getNode("/systems/ignition/starter-1"),
	starter2: props.globals.getNode("/systems/ignition/starter-2"),
	starter3: props.globals.getNode("/systems/ignition/starter-3"),
	Switch: {
		ign: props.globals.getNode("/controls/ignition/switches/ign"),
		ignOvrd: props.globals.getNode("/controls/ignition/switches/ign-ovrd"),
	},
	init: func() {
		me.Switch.ign.setValue(0);
		me.Switch.ignOvrd.setBoolValue(0);
	},
	fastStart: func(n) {
		ENGINE.cutoffSwitch[n].setBoolValue(0);
		pts.Fdm.JSBSim.Propulsion.setRunning.setValue(n);
	},
	fastStop: func(n) {
		ENGINE.cutoffSwitch[n].setBoolValue(1);
		settimer(func() { # Required delay
			if (pts.Engines.Engine.n2Actual[n].getValue() > 1) {
				pts.Fdm.JSBSim.Propulsion.Engine.n1[n].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.Engine.n2[n].setValue(0.1);
			}
		}, 0.1);
	},
};

# Thrust Limits
var THRLIM = {
	Limit: {
		activeModeInt: props.globals.getNode("/fdm/jsbsim/engine/limit/active-mode-int"), # -1 NONE, 0 T/O, 1 FLX/ALTN T/O, 2 G/A, 3 MCT, 4 CL, 5 MCR/ALTN CL
		activeNorm: props.globals.getNode("/fdm/jsbsim/engine/limit/active-norm"),
		flexTemp: props.globals.getNode("/fdm/jsbsim/engine/limit/flex-temp"),
		highestNorm: props.globals.getNode("/fdm/jsbsim/engine/limit/highest-norm"),
	},
	throttleCompareMax: props.globals.getNode("/fdm/jsbsim/engine/throttle-compare-max"),
	init: func() {
		me.Limit.activeModeInt.setValue(0);
	},
	setMode: func(m) {
		me.Limit.activeModeIntLast = me.Limit.activeModeInt.getValue();
		me.Limit.activeModeInt.setValue(m);
	},
};

# Warnings
var WARNINGS = {
	altitudeAlert: props.globals.getNode("/systems/caws/logic/altitude-alert"),
	altitudeAlertCaptured: props.globals.getNode("/systems/caws/logic/altitude-alert-captured"),
};
