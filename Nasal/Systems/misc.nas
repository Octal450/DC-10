# McDonnell Douglas DC-10 Misc Systems
# Copyright (c) 2024 Josh Davidson (Octal450)

# APU
var APU = {
	egt: props.globals.getNode("/engines/engine[3]/egt-actual"),
	ff: props.globals.getNode("/engines/engine[3]/ff-actual"),
	n1: props.globals.getNode("/engines/engine[3]/n1-actual"),
	n2: props.globals.getNode("/engines/engine[3]/n2-actual"),
	state: props.globals.getNode("/engines/engine[3]/state"),
	Controls: {
		master: props.globals.getNode("/controls/apu/master"),
	},
	init: func() {
		me.Controls.master.setValue(0);
	},
	fastStart: func() {
		me.Controls.master.setValue(1);
		settimer(func() { # Give the fuel system a moment to provide fuel in the pipe
			pts.Fdm.JSBSim.Propulsion.setRunning.setValue(3);
		}, 1);
	},
	stopRpm: func() {
		settimer(func() { # Required delay
			if (me.n2.getValue() >= 1) {
				pts.Fdm.JSBSim.Propulsion.ENGINES.n1[3].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.ENGINES.n2[3].setValue(0.1);
			}
		}, 0.1);
	},
};

# Engine Control
var ENGINES = {
	egtActual: [props.globals.getNode("/engines/engine[0]/egt-actual"), props.globals.getNode("/engines/engine[1]/egt-actual"), props.globals.getNode("/engines/engine[2]/egt-actual")],
	eprActual: [props.globals.getNode("/engines/engine[0]/epr-actual"), props.globals.getNode("/engines/engine[1]/epr-actual"), props.globals.getNode("/engines/engine[2]/epr-actual")],
	ffActual: [props.globals.getNode("/engines/engine[0]/ff-actual"), props.globals.getNode("/engines/engine[1]/ff-actual"), props.globals.getNode("/engines/engine[2]/ff-actual")],
	n1Actual: [props.globals.getNode("/engines/engine[0]/n1-actual"), props.globals.getNode("/engines/engine[1]/n1-actual"), props.globals.getNode("/engines/engine[2]/n1-actual")],
	n2Actual: [props.globals.getNode("/engines/engine[0]/n2-actual"), props.globals.getNode("/engines/engine[1]/n2-actual"), props.globals.getNode("/engines/engine[2]/n2-actual")],
	nacelleTemp: [props.globals.getNode("/engines/engine[0]/nacelle-temp"), props.globals.getNode("/engines/engine[1]/nacelle-temp"), props.globals.getNode("/engines/engine[2]/nacelle-temp")],
	oilPsi: [props.globals.getNode("/engines/engine[0]/oil-psi"), props.globals.getNode("/engines/engine[1]/oil-psi"), props.globals.getNode("/engines/engine[2]/oil-psi")],
	oilQty: [props.globals.getNode("/engines/engine[0]/oil-qty"), props.globals.getNode("/engines/engine[1]/oil-qty"), props.globals.getNode("/engines/engine[2]/oil-qty")],
	oilQtyInput: [props.globals.getNode("/engines/engine[0]/oil-qty-input"), props.globals.getNode("/engines/engine[1]/oil-qty-input"), props.globals.getNode("/engines/engine[2]/oil-qty-input")],
	oilTemp: [props.globals.getNode("/engines/engine[0]/oil-temp"), props.globals.getNode("/engines/engine[1]/oil-temp"), props.globals.getNode("/engines/engine[2]/oil-temp")],
	overspeed: props.globals.getNode("/systems/engines/limit/overspeed"),
	state: [props.globals.getNode("/engines/engine[0]/state"), props.globals.getNode("/engines/engine[1]/state"), props.globals.getNode("/engines/engine[2]/state")],
	Controls: {
		cutoff: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[2]/cutoff-switch")],
		eprTemp: 0,
		manEpr: [props.globals.getNode("/controls/engines/engine[0]/man-epr"), props.globals.getNode("/controls/engines/engine[1]/man-epr"), props.globals.getNode("/controls/engines/engine[2]/man-epr")],
		manEprSet: [props.globals.getNode("/controls/engines/engine[0]/man-epr-set"), props.globals.getNode("/controls/engines/engine[1]/man-epr-set"), props.globals.getNode("/controls/engines/engine[2]/man-epr-set")],
		manN1: [props.globals.getNode("/controls/engines/engine[0]/man-n1"), props.globals.getNode("/controls/engines/engine[1]/man-n1"), props.globals.getNode("/controls/engines/engine[2]/man-n1")],
		manN1Set: [props.globals.getNode("/controls/engines/engine[0]/man-n1-set"), props.globals.getNode("/controls/engines/engine[1]/man-n1-set"), props.globals.getNode("/controls/engines/engine[2]/man-n1-set")],
		n1Temp: 0,
		reverseEngage: [props.globals.getNode("/controls/engines/engine[0]/reverse-engage"), props.globals.getNode("/controls/engines/engine[1]/reverse-engage"), props.globals.getNode("/controls/engines/engine[2]/reverse-engage")],
		start: [props.globals.getNode("/controls/engines/engine[0]/start-switch"), props.globals.getNode("/controls/engines/engine[1]/start-switch"), props.globals.getNode("/controls/engines/engine[2]/start-switch")],
		startCmd: [props.globals.getNode("/controls/engines/engine[0]/start-cmd"), props.globals.getNode("/controls/engines/engine[1]/start-cmd"), props.globals.getNode("/controls/engines/engine[2]/start-cmd")],
		throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle"), props.globals.getNode("/controls/engines/engine[2]/throttle")],
		throttleTemp: [0, 0, 0],
	},
	init: func() {
		me.Controls.manEpr[0].setValue(1.5);
		me.Controls.manEpr[1].setValue(1.5);
		me.Controls.manEpr[2].setValue(1.5);
		me.Controls.manEprSet[0].setBoolValue(0);
		me.Controls.manEprSet[1].setBoolValue(0);
		me.Controls.manEprSet[2].setBoolValue(0);
		me.Controls.manN1[0].setValue(110);
		me.Controls.manN1[1].setValue(110);
		me.Controls.manN1[2].setValue(110);
		me.Controls.manN1Set[0].setBoolValue(0);
		me.Controls.manN1Set[1].setBoolValue(0);
		me.Controls.manN1Set[2].setBoolValue(0);
		me.Controls.reverseEngage[0].setBoolValue(0);
		me.Controls.reverseEngage[1].setBoolValue(0);
		me.Controls.reverseEngage[2].setBoolValue(0);
		me.Controls.start[0].setBoolValue(0);
		me.Controls.start[1].setBoolValue(0);
		me.Controls.start[2].setBoolValue(0);
		me.Controls.startCmd[0].setBoolValue(0);
		me.Controls.startCmd[1].setBoolValue(0);
		me.Controls.startCmd[2].setBoolValue(0);
	},
	adjustManEpr: func(n, d) {
		if (me.Controls.manEprSet[n].getBoolValue() and pts.Instrumentation.Epr.powerAvail[n].getBoolValue()) {
			me.Controls.eprTemp = math.round(me.Controls.manEpr[n].getValue() + (d * 0.01), (abs(d * 0.01))); # Kill floating point error
			if (me.Controls.eprTemp < 1) {
				me.Controls.manEpr[n].setValue(1);
			} else if (me.Controls.eprTemp > 2.0) {
				me.Controls.manEpr[n].setValue(2.0);
			} else {
				me.Controls.manEpr[n].setValue(me.Controls.eprTemp);
			}
		}
	},
	adjustManN1: func(n, d) {
		if (me.Controls.manN1Set[n].getBoolValue() and pts.Instrumentation.N.powerAvail[n].getBoolValue()) {
			me.Controls.n1Temp = math.round(me.Controls.manN1[n].getValue() + (d * 0.1), (abs(d * 0.1))); # Kill floating point error
			if (me.Controls.n1Temp < 0) {
				me.Controls.manN1[n].setValue(0);
			} else if (me.Controls.n1Temp > 120) {
				me.Controls.manN1[n].setValue(120);
			} else {
				me.Controls.manN1[n].setValue(me.Controls.n1Temp);
			}
		}
	},
};

# Base off Engine 2
var doRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		ENGINES.Controls.throttleTemp[1] = ENGINES.Controls.throttle[1].getValue();
		if (!ENGINES.Controls.reverseEngage[0].getBoolValue() or !ENGINES.Controls.reverseEngage[1].getBoolValue() or !ENGINES.Controls.reverseEngage[2].getBoolValue()) {
			ENGINES.Controls.reverseEngage[0].setBoolValue(1);
			ENGINES.Controls.reverseEngage[1].setBoolValue(1);
			ENGINES.Controls.reverseEngage[2].setBoolValue(1);
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
			ENGINES.Controls.throttle[2].setValue(0);
		} else if (ENGINES.Controls.throttleTemp[1] < 0.4) {
			ENGINES.Controls.throttle[0].setValue(0.4);
			ENGINES.Controls.throttle[1].setValue(0.4);
			ENGINES.Controls.throttle[2].setValue(0.4);
		} else if (ENGINES.Controls.throttleTemp[1] < 0.7) {
			ENGINES.Controls.throttle[0].setValue(0.7);
			ENGINES.Controls.throttle[1].setValue(0.7);
			ENGINES.Controls.throttle[2].setValue(0.7);
		} else if (ENGINES.Controls.throttleTemp[1] < 1) {
			ENGINES.Controls.throttle[0].setValue(1);
			ENGINES.Controls.throttle[1].setValue(1);
			ENGINES.Controls.throttle[2].setValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		ENGINES.Controls.reverseEngage[0].setBoolValue(0);
		ENGINES.Controls.reverseEngage[1].setBoolValue(0);
		ENGINES.Controls.reverseEngage[2].setBoolValue(0);
	}
}

var unRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINES.Controls.reverseEngage[0].getBoolValue() or ENGINES.Controls.reverseEngage[1].getBoolValue() or ENGINES.Controls.reverseEngage[2].getBoolValue()) {
			ENGINES.Controls.throttleTemp[1] = ENGINES.Controls.throttle[1].getValue();
			if (ENGINES.Controls.throttleTemp[1] > 0.7) {
				ENGINES.Controls.throttle[0].setValue(0.7);
				ENGINES.Controls.throttle[1].setValue(0.7);
				ENGINES.Controls.throttle[2].setValue(0.7);
			} else if (ENGINES.Controls.throttleTemp[1] > 0.4) {
				ENGINES.Controls.throttle[0].setValue(0.4);
				ENGINES.Controls.throttle[1].setValue(0.4);
				ENGINES.Controls.throttle[2].setValue(0.4);
			} else if (ENGINES.Controls.throttleTemp[1] > 0.05) {
				ENGINES.Controls.throttle[0].setValue(0);
				ENGINES.Controls.throttle[1].setValue(0);
				ENGINES.Controls.throttle[2].setValue(0);
			} else {
				ENGINES.Controls.throttle[0].setValue(0);
				ENGINES.Controls.throttle[1].setValue(0);
				ENGINES.Controls.throttle[2].setValue(0);
				ENGINES.Controls.reverseEngage[0].setBoolValue(0);
				ENGINES.Controls.reverseEngage[1].setBoolValue(0);
				ENGINES.Controls.reverseEngage[2].setBoolValue(0);
			}
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		ENGINES.Controls.reverseEngage[0].setBoolValue(0);
		ENGINES.Controls.reverseEngage[1].setBoolValue(0);
		ENGINES.Controls.reverseEngage[2].setBoolValue(0);
	}
}

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINES.Controls.reverseEngage[0].getBoolValue() or ENGINES.Controls.reverseEngage[1].getBoolValue() or ENGINES.Controls.reverseEngage[2].getBoolValue()) {
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
			ENGINES.Controls.throttle[2].setValue(0);
			ENGINES.Controls.reverseEngage[0].setBoolValue(0);
			ENGINES.Controls.reverseEngage[1].setBoolValue(0);
			ENGINES.Controls.reverseEngage[2].setBoolValue(0);
		} else {
			ENGINES.Controls.reverseEngage[0].setBoolValue(1);
			ENGINES.Controls.reverseEngage[1].setBoolValue(1);
			ENGINES.Controls.reverseEngage[2].setBoolValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		ENGINES.Controls.reverseEngage[0].setBoolValue(0);
		ENGINES.Controls.reverseEngage[1].setBoolValue(0);
		ENGINES.Controls.reverseEngage[2].setBoolValue(0);
	}
}

var doIdleThrust = func() {
	ENGINES.Controls.throttle[0].setValue(0);
	ENGINES.Controls.throttle[1].setValue(0);
	ENGINES.Controls.throttle[2].setValue(0);
}

var doLimitThrust = func() {
	var active = THRLIM.Limit.activeNorm.getValue();
	ENGINES.Controls.throttle[0].setValue(active);
	ENGINES.Controls.throttle[1].setValue(active);
	ENGINES.Controls.throttle[2].setValue(active);
}

var doFullThrust = func() {
	var highest = THRLIM.Limit.highestNorm.getValue();
	ENGINES.Controls.throttle[0].setValue(highest);
	ENGINES.Controls.throttle[1].setValue(highest);
	ENGINES.Controls.throttle[2].setValue(highest);
}

# Flight Control Computers
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

# Flight Control Systems
var FCS = {
	slatsCmd: props.globals.getNode("/systems/fcs/slats/cmd"),
};

# Landing Gear
var GEAR = {
	Controls: {
		brakeLeft: props.globals.getNode("/controls/gear/brake-left"),
		brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		brakeRight: props.globals.getNode("/controls/gear/brake-right"),
		centerGearUp: props.globals.getNode("/controls/gear/center-gear-up"),
		lever: props.globals.getNode("/controls/gear/lever"),
		leverCockpit: props.globals.getNode("/controls/gear/lever-cockpit"),
	},
	Failures: {
		centerActuator: props.globals.getNode("/systems/failures/gear/center-actuator"),
		leftActuator: props.globals.getNode("/systems/failures/gear/left-actuator"),
		noseActuator: props.globals.getNode("/systems/failures/gear/nose-actuator"),
		rightActuator: props.globals.getNode("/systems/failures/gear/right-actuator"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.brakeParking.setBoolValue(0);
		me.Controls.centerGearUp.setBoolValue(0);
	},
	resetFailures: func() {
		me.Failures.centerActuator.setBoolValue(0);
		me.Failures.leftActuator.setBoolValue(0);
		me.Failures.noseActuator.setBoolValue(0);
		me.Failures.rightActuator.setBoolValue(0);
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
	Controls: {
		ign: props.globals.getNode("/controls/ignition/ign"),
		ignOvrd: props.globals.getNode("/controls/ignition/ign-ovrd"),
	},
	init: func() {
		me.Controls.ign.setValue(0);
		me.Controls.ignOvrd.setBoolValue(0);
	},
	fastStart: func(n) {
		ENGINES.Controls.cutoff[n].setBoolValue(0);
		pts.Fdm.JSBSim.Propulsion.setRunning.setValue(n);
	},
	fastStop: func(n) {
		ENGINES.Controls.cutoff[n].setBoolValue(1);
		settimer(func() { # Required delay
			if (systems.ENGINES.n2[n].getValue() > 1) {
				pts.Fdm.JSBSim.Propulsion.ENGINES.n1[n].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.ENGINES.n2[n].setValue(0.1);
			}
		}, 0.1);
	},
};

# Thrust Limits
var THRLIM = {
	Limit: {
		activeModeInt: props.globals.getNode("/systems/engines/limit/active-mode-int"), # -1 NONE, 0 T/O, 1 FLX/ALTN T/O, 2 G/A, 3 MCT, 4 CL, 5 MCR/ALTN CL
		activeNorm: props.globals.getNode("/systems/engines/limit/active-norm"),
		flexTemp: props.globals.getNode("/systems/engines/limit/flex-temp"),
		highestNorm: props.globals.getNode("/systems/engines/limit/highest-norm"),
	},
	throttleCompareMax: props.globals.getNode("/systems/engines/throttle-compare-max"),
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
