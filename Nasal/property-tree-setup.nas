# McDonnell Douglas DC-10 Property Tree Setup
# Copyright (c) 2024 Josh Davidson (Octal450)
# Nodes organized like property tree, except when lots of identical (example: Gear wow), where vectors are used to make it easier
# Anything that says Temp is set by another file to avoid multiple getValue calls
# Usage Example: pts.Class.SubClass.node.getValue()

var Controls = {
	Flight: {
		aileronDrivesTiller: props.globals.getNode("/controls/flight/aileron-drives-tiller"),
		autoCoordination: props.globals.getNode("/controls/flight/auto-coordination", 1),
		dialAFlap: props.globals.getNode("/controls/flight/dial-a-flap"),
		elevatorTrim: props.globals.getNode("/controls/flight/elevator-trim"),
		flaps: props.globals.getNode("/controls/flight/flaps"),
		flapsCmd: props.globals.getNode("/controls/flight/flaps-cmd"),
		flapsTemp: 0,
		flapsInput: props.globals.getNode("/controls/flight/flaps-input"),
		speedbrake: props.globals.getNode("/controls/flight/speedbrake"),
		speedbrakeArm: props.globals.getNode("/controls/flight/speedbrake-arm"),
		speedbrakeTemp: 0,
		slatsCmd: props.globals.getNode("/controls/flight/slats-cmd"),
		wingflexEnable: props.globals.getNode("/controls/flight/wingflex-enable"),
	},
	Switches: {
		adgHandle: props.globals.getNode("/controls/switches/adg-handle"),
		annunTest: props.globals.getNode("/controls/switches/annun-test"),
		minimums: props.globals.getNode("/controls/switches/minimums"),
		noSmokingSign: props.globals.getNode("/controls/switches/no-smoking-sign"),
		seatbeltSign: props.globals.getNode("/controls/switches/seatbelt-sign"),
	},
};

var Engines = {
	Engine: {
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
		state: [props.globals.getNode("/engines/engine[0]/state"), props.globals.getNode("/engines/engine[1]/state"), props.globals.getNode("/engines/engine[2]/state")],
	},
};

var Fdm = {
	JSBSim: {
		Contact: {
			anyWowOut: props.globals.getNode("/fdm/jsbsim/contact/any-wow-out"),
		},
		Engine: {
			Limit: {
				overspeed: props.globals.getNode("/fdm/jsbsim/engine/limit/overspeed"),
			},
		},
		Fcc: {
			nlgTimer1: {
				wowTimer: props.globals.getNode("/fdm/jsbsim/fcc/nlg-timer-1/wow-timer"),
			},
		},
		Fcs: {
			flapPosDeg: props.globals.getNode("/fdm/jsbsim/fcs/flap-pos-deg"),
			Slat: {
				cmdDeg: props.globals.getNode("/fdm/jsbsim/fcs/slat/cmd-deg"),
			},
			slatPosDeg: props.globals.getNode("/fdm/jsbsim/fcs/slat-pos-deg"),
		},
		Gear: {
			gearAllNorm: props.globals.getNode("/fdm/jsbsim/gear/gear-all-norm"),
		},
		Hydraulics: {
			Stabilizer: {
				finalDeg: props.globals.getNode("/fdm/jsbsim/hydraulics/stabilizer/final-deg"),
			},
		},
		Inertia: {
			weightLbs: props.globals.getNode("/fdm/jsbsim/inertia/weight-lbs"),
		},
		Performance: {
			stabilizerDeg: props.globals.getNode("/fdm/jsbsim/performance/stabilizer-deg"),
		},
		Position: {
			wow: props.globals.getNode("/fdm/jsbsim/position/wow"),
			wowTemp: 0,
		},
		Propulsion: {
			Engine: {
				n1: [props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/n1"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/n1"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/n1"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[3]/n1")],
				n2: [props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/n2"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/n2"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/n2"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[3]/n2")],
			},
			setRunning: props.globals.getNode("/fdm/jsbsim/propulsion/set-running"),
			tatC: props.globals.getNode("/fdm/jsbsim/propulsion/tat-c"),
		},
	},
};

var Gear = {
	rollspeedMs: [props.globals.getNode("/gear/gear[0]/rollspeed-ms"), props.globals.getNode("/gear/gear[1]/rollspeed-ms"), props.globals.getNode("/gear/gear[2]/rollspeed-ms"), props.globals.getNode("/gear/gear[3]/rollspeed-ms")],
	wow: [props.globals.getNode("/gear/gear[0]/wow"), props.globals.getNode("/gear/gear[1]/wow"), props.globals.getNode("/gear/gear[2]/wow"), props.globals.getNode("/gear/gear[3]/wow")],
};

var Instrumentation = {
	AirspeedIndicator: {
		indicatedMach: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach"),
		indicatedSpeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt"),
	},
	Comm: {
		Frequencies: {
			standbyMhz: [props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz"), props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz"), props.globals.getNode("/instrumentation/comm[2]/frequencies/standby-mhz")],
			standbyMhzFmt: [props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz-fmt"), props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz-fmt"), props.globals.getNode("/instrumentation/comm[2]/frequencies/standby-mhz-fmt")],
		},
	},
	Epr: {
		powerAvail: [props.globals.getNode("/instrumentation/epr[0]/power-avail"), props.globals.getNode("/instrumentation/epr[1]/power-avail"), props.globals.getNode("/instrumentation/epr[2]/power-avail")],
	},
	Hsi: {
		slavedToGps: [props.globals.getNode("/instrumentation/hsi[0]/slaved-to-gps"), props.globals.getNode("/instrumentation/hsi[1]/slaved-to-gps")],
	},
	MarkerBeacon: {
		inner: props.globals.getNode("/instrumentation/marker-beacon/inner"),
		middle: props.globals.getNode("/instrumentation/marker-beacon/middle"),
		outer: props.globals.getNode("/instrumentation/marker-beacon/outer"),
	},
	N: {
		powerAvail: [props.globals.getNode("/instrumentation/n[0]/power-avail"), props.globals.getNode("/instrumentation/n[1]/power-avail"), props.globals.getNode("/instrumentation/n[2]/power-avail")],
	},
	Nav: {
		Frequencies: {
			selectedMhz: [props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz")],
			selectedMhzFmt: [props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz-fmt"), props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz-fmt")],
			selectedMhzFmtX100: [props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz-fmt-x100"), props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz-fmt-x100")],
		},
		headingNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[2]/heading-needle-deflection-norm")],
		gsInRange: [props.globals.getNode("/instrumentation/nav[0]/gs-in-range"), props.globals.getNode("/instrumentation/nav[1]/gs-in-range")],
		gsNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/gs-needle-deflection-norm")],
		hasGs: [props.globals.getNode("/instrumentation/nav[0]/has-gs"), props.globals.getNode("/instrumentation/nav[1]/has-gs")],
		inRange: [props.globals.getNode("/instrumentation/nav[0]/in-range"), props.globals.getNode("/instrumentation/nav[1]/in-range")],
		navLoc: [props.globals.getNode("/instrumentation/nav[0]/nav-loc"), props.globals.getNode("/instrumentation/nav[1]/nav-loc")],
		signalQualityNorm: [props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm"), props.globals.getNode("/instrumentation/nav[1]/signal-quality-norm")],
	},
};

var Options = {
	eng: props.globals.getNode("/options/eng"),
};

var Orientation = {
	pitchDeg: props.globals.getNode("/orientation/pitch-deg"),
	rollDeg: props.globals.getNode("/orientation/roll-deg"),
};

var Payload = {
	Armament: {
		msg: props.globals.getNode("/payload/armament/msg"),
	},
};

var Position = {
	gearAglFt: props.globals.getNode("/position/gear-agl-ft"),
};

var Services = {
	Chocks: {
		enable: props.globals.getNode("/services/chocks/enable"),
		enableTemp: 1,
	},
};

var Sim = {
	CurrentView: {
		fieldOfView: props.globals.getNode("/sim/current-view/field-of-view", 1),
		headingOffsetDeg: props.globals.getNode("/sim/current-view/heading-offset-deg", 1),
		name: props.globals.getNode("/sim/current-view/name", 1),
		pitchOffsetDeg: props.globals.getNode("/sim/current-view/pitch-offset-deg", 1),
		rollOffsetDeg: props.globals.getNode("/sim/current-view/roll-offset-deg", 1),
		viewNumber: props.globals.getNode("/sim/current-view/view-number", 1),
		viewNumberRaw: props.globals.getNode("/sim/current-view/view-number-raw", 1),
		xOffsetM: props.globals.getNode("/sim/current-view/x-offset-m", 1),
		yOffsetM: props.globals.getNode("/sim/current-view/y-offset-m", 1),
		zOffsetDefault: props.globals.getNode("/sim/current-view/z-offset-default", 1),
		zOffsetM: props.globals.getNode("/sim/current-view/z-offset-m", 1),
		zOffsetMaxM: props.globals.getNode("/sim/current-view/z-offset-max-m", 1),
		zOffsetMinM: props.globals.getNode("/sim/current-view/z-offset-min-m", 1),
	},
	Rendering: {
		Headshake: {
			enabled: props.globals.getNode("/sim/rendering/headshake/enabled"),
		},
	},
	Replay: {
		replayState: props.globals.getNode("/sim/replay/replay-state"),
		wasActive: props.globals.initNode("/sim/replay/was-active", 0, "BOOL"),
	},
	Sound: {
		btn1: props.globals.initNode("/sim/sound/btn1", 0, "BOOL"),
		btn2: props.globals.initNode("/sim/sound/btn2", 0, "BOOL"),
		btn3: props.globals.initNode("/sim/sound/btn3", 0, "BOOL"),
		flapsClick: props.globals.initNode("/sim/sound/flaps-click", 0, "BOOL"),
		knb1: props.globals.initNode("/sim/sound/knb1", 0, "BOOL"),
		noSmokingSign: props.globals.initNode("/sim/sound/no-smoking-sign", 0, "BOOL"),
		noSmokingSignInhibit: props.globals.initNode("/sim/sound/no-smoking-sign-inhibit", 0, "BOOL"),
		seatbeltSign: props.globals.initNode("/sim/sound/seatbelt-sign", 0, "BOOL"),
		switch1: props.globals.initNode("/sim/sound/switch1", 0, "BOOL"),
	},
	Time: {
		deltaRealtimeSec: props.globals.getNode("/sim/time/delta-realtime-sec"),
		elapsedSec: props.globals.getNode("/sim/time/elapsed-sec"),
	},
	View: {
		Config: {
			defaultFieldOfViewDeg: props.globals.getNode("/sim/view/config/default-field-of-view-deg", 1),
		},
	},
};

var Systems = {
	Shake: {
		shaking: props.globals.getNode("/systems/shake/shaking"),
	},
};

var Velocities = {
	groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt"),
	groundspeedKtTemp: 0,
	speedDownFps: props.globals.getNode("/velocities/speed-down-fps"),
	speedEastFps: props.globals.getNode("/velocities/speed-east-fps"),
	speedNorthFps: props.globals.getNode("/velocities/speed-north-fps"),
};
