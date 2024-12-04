# McDonnell Douglas DC-10 APU
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
				pts.Fdm.JSBSim.Propulsion.Engine.n1[3].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.Engine.n2[3].setValue(0.1);
			}
		}, 0.1);
	},
};
