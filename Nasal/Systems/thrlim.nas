# McDonnell Douglas DC-10 Thrust Limits
# Copyright (c) 2026 Josh Davidson (Octal450)

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
