# McDonnell Douglas DC-10 Engines
# Copyright (c) 2025 Josh Davidson (Octal450)

var ENGINES = {
	egt: [props.globals.getNode("/engines/engine[0]/egt-actual"), props.globals.getNode("/engines/engine[1]/egt-actual"), props.globals.getNode("/engines/engine[2]/egt-actual")],
	epr: [props.globals.getNode("/engines/engine[0]/epr-actual"), props.globals.getNode("/engines/engine[1]/epr-actual"), props.globals.getNode("/engines/engine[2]/epr-actual")],
	ff: [props.globals.getNode("/engines/engine[0]/ff-actual"), props.globals.getNode("/engines/engine[1]/ff-actual"), props.globals.getNode("/engines/engine[2]/ff-actual")],
	n1: [props.globals.getNode("/engines/engine[0]/n1-actual"), props.globals.getNode("/engines/engine[1]/n1-actual"), props.globals.getNode("/engines/engine[2]/n1-actual")],
	n2: [props.globals.getNode("/engines/engine[0]/n2-actual"), props.globals.getNode("/engines/engine[1]/n2-actual"), props.globals.getNode("/engines/engine[2]/n2-actual")],
	nacelleTemp: [props.globals.getNode("/engines/engine[0]/nacelle-temp"), props.globals.getNode("/engines/engine[1]/nacelle-temp"), props.globals.getNode("/engines/engine[2]/nacelle-temp")],
	oilPsi: [props.globals.getNode("/engines/engine[0]/oil-psi"), props.globals.getNode("/engines/engine[1]/oil-psi"), props.globals.getNode("/engines/engine[2]/oil-psi")],
	oilQty: [props.globals.getNode("/engines/engine[0]/oil-qty"), props.globals.getNode("/engines/engine[1]/oil-qty"), props.globals.getNode("/engines/engine[2]/oil-qty")],
	oilQtyInput: [props.globals.getNode("/engines/engine[0]/oil-qty-input"), props.globals.getNode("/engines/engine[1]/oil-qty-input"), props.globals.getNode("/engines/engine[2]/oil-qty-input")],
	oilTemp: [props.globals.getNode("/engines/engine[0]/oil-temp"), props.globals.getNode("/engines/engine[1]/oil-temp"), props.globals.getNode("/engines/engine[2]/oil-temp")],
	overspeed: props.globals.getNode("/systems/engines/limit/overspeed"),
	reverseEngage: [props.globals.getNode("/systems/engines/reverse-1/engage"), props.globals.getNode("/systems/engines/reverse-2/engage"), props.globals.getNode("/systems/engines/reverse-3/engage")],
	state: [props.globals.getNode("/engines/engine[0]/state"), props.globals.getNode("/engines/engine[1]/state"), props.globals.getNode("/engines/engine[2]/state")],
	Controls: {
		cutoff: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[2]/cutoff-switch")],
		eprTemp: 0,
		manEpr: [props.globals.getNode("/controls/engines/engine[0]/man-epr"), props.globals.getNode("/controls/engines/engine[1]/man-epr"), props.globals.getNode("/controls/engines/engine[2]/man-epr")],
		manEprSet: [props.globals.getNode("/controls/engines/engine[0]/man-epr-set"), props.globals.getNode("/controls/engines/engine[1]/man-epr-set"), props.globals.getNode("/controls/engines/engine[2]/man-epr-set")],
		manN1: [props.globals.getNode("/controls/engines/engine[0]/man-n1"), props.globals.getNode("/controls/engines/engine[1]/man-n1"), props.globals.getNode("/controls/engines/engine[2]/man-n1")],
		manN1Set: [props.globals.getNode("/controls/engines/engine[0]/man-n1-set"), props.globals.getNode("/controls/engines/engine[1]/man-n1-set"), props.globals.getNode("/controls/engines/engine[2]/man-n1-set")],
		n1Temp: 0,
		start: [props.globals.getNode("/controls/engines/engine[0]/start-switch"), props.globals.getNode("/controls/engines/engine[1]/start-switch"), props.globals.getNode("/controls/engines/engine[2]/start-switch")],
		startCmd: [props.globals.getNode("/controls/engines/engine[0]/start-cmd"), props.globals.getNode("/controls/engines/engine[1]/start-cmd"), props.globals.getNode("/controls/engines/engine[2]/start-cmd")],
		throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle"), props.globals.getNode("/controls/engines/engine[2]/throttle")],
		throttleTemp: [0, 0, 0],
	},
	init: func() {
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.reverseEngage[2].setBoolValue(0);
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
		if (!ENGINES.reverseEngage[0].getBoolValue() or !ENGINES.reverseEngage[1].getBoolValue() or !ENGINES.reverseEngage[2].getBoolValue()) {
			ENGINES.reverseEngage[0].setBoolValue(1);
			ENGINES.reverseEngage[1].setBoolValue(1);
			ENGINES.reverseEngage[2].setBoolValue(1);
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
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
		ENGINES.reverseEngage[2].setBoolValue(0);
	}
}

var unRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINES.reverseEngage[0].getBoolValue() or ENGINES.reverseEngage[1].getBoolValue() or ENGINES.reverseEngage[2].getBoolValue()) {
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
				ENGINES.reverseEngage[0].setBoolValue(0);
				ENGINES.reverseEngage[1].setBoolValue(0);
				ENGINES.reverseEngage[2].setBoolValue(0);
			}
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
		ENGINES.reverseEngage[2].setBoolValue(0);
	}
}

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINES.reverseEngage[0].getBoolValue() or ENGINES.reverseEngage[1].getBoolValue() or ENGINES.reverseEngage[2].getBoolValue()) {
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
			ENGINES.Controls.throttle[2].setValue(0);
			ENGINES.reverseEngage[0].setBoolValue(0);
			ENGINES.reverseEngage[1].setBoolValue(0);
			ENGINES.reverseEngage[2].setBoolValue(0);
		} else {
			ENGINES.reverseEngage[0].setBoolValue(1);
			ENGINES.reverseEngage[1].setBoolValue(1);
			ENGINES.reverseEngage[2].setBoolValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
		ENGINES.reverseEngage[2].setBoolValue(0);
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
