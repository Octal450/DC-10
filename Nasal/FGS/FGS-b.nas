# McDonnell Douglas DC-10 FGS
# Copyright (c) 2024 Josh Davidson (Octal450)

var Fma = {
	armA: props.globals.initNode("/instrumentation/fma/arm-mode-a", "", "STRING"),
	armB: props.globals.initNode("/instrumentation/fma/arm-mode-b", "", "STRING"),
	pitchA: props.globals.initNode("/instrumentation/fma/pitch-mode-a", "", "STRING"),
	pitchB: props.globals.initNode("/instrumentation/fma/pitch-mode-b", "", "STRING"),
	rollA: props.globals.initNode("/instrumentation/fma/roll-mode-a", "", "STRING"),
	rollB: props.globals.initNode("/instrumentation/fma/roll-mode-b", "", "STRING"),
	thrA: props.globals.initNode("/instrumentation/fma/thr-mode-a", "", "STRING"),
	thrB: props.globals.initNode("/instrumentation/fma/thr-mode-b", "", "STRING"),
};

var Speeds = {
	vmin: props.globals.getNode("/systems/fcc/speeds/vmin"),
};

var UpdateFma = {
	latText: "T/O",
	thrTemp: 0,
	vertText: "T/O CLB",
	capTrkReCheck: func() {
		me.locUpdate();
		locUpdateT.start();
		me.gsUpdate();
		gsUpdateT.start();
	},
	lat: func() {
		me.latText = Text.lat.getValue();
		if (me.latText == "HDG") {
			Fma.rollA.setValue("HDG");
			if (Output.hdgInHld.getBoolValue()) {
				Fma.rollB.setValue("HOLD");
			} else {
				Fma.rollB.setValue("SEL");
			}
		} else if (me.latText == "LNAV") {
			Fma.rollA.setValue("FMS");
			Fma.rollB.setValue("TRK");
		} else if (me.latText == "LOC") {
			if (pts.Instrumentation.Nav.navLoc[ITAF.activeRadioSel()].getBoolValue()) {
				Fma.rollA.setValue("LOC");
			} else {
				Fma.rollA.setValue("VOR");
			}
			me.locUpdate();
			locUpdateT.start();
		} else if (me.latText == "ALIGN") {
			Fma.rollA.setValue("ALGN");
			Fma.rollB.setValue("");
		} else if (me.latText == "ROLLOUT") {
			Fma.rollA.setValue("ROLL");
			Fma.rollB.setValue("OUT");
		} else if (me.latText == "T/O") {
			Fma.rollA.setValue("TAKE");
			Fma.rollB.setValue("OFF");
		} else if (me.latText == "G/A") {
			Fma.rollA.setValue("G/A");
			Fma.rollB.setValue("");
		}
	},
	vert: func() {
		me.vertText = Text.vert.getValue();
		if (me.vertText == "FLCH") { # Replaces SPD CLB/DES from ITAF Core
			if (Input.ktsMachFlch.getBoolValue()) {
				Fma.pitchA.setValue("MACH");
				Fma.pitchB.setValue("HOLD");
			} else {
				Fma.pitchA.setValue("IAS");
				Fma.pitchB.setValue("HOLD");
			}
		} else if (me.vertText == "T/O CLB") {
			Fma.pitchA.setValue("TAKE");
			Fma.pitchB.setValue("OFF");
		} else if (me.vertText == "G/A CLB") {
			Fma.pitchA.setValue("G/A");
			Fma.pitchB.setValue("");
		} else if (me.vertText == "ALT HLD") {
			Fma.pitchA.setValue("ALT");
			Fma.pitchB.setValue("HOLD");
		} else if (me.vertText == "ALT CAP") {
			Fma.pitchA.setValue("ALT");
			Fma.pitchB.setValue("CAP");
		} else if (me.vertText == "V/S") {
			Fma.pitchA.setValue("VERT");
			Fma.pitchB.setValue("SPD");
		} else if (me.vertText == "G/S") {
			Fma.pitchA.setValue("G/S");
			me.gsUpdate();
			gsUpdateT.start();
		} else if (me.vertText == "FPA") {
			Fma.pitchA.setValue("");
			Fma.pitchB.setValue("");
		} else if (me.vertText == "FLARE") {
			Fma.pitchA.setValue("FLARE");
			Fma.pitchB.setValue("");
		} else if (me.vertText == "TURB") {
			Fma.pitchA.setValue("TURB");
			Fma.pitchB.setValue("");
		}
	},
	arm: func() {
		me.vertText = Text.vert.getValue();
		if (Internal.landCondition == "DUAL") {
			Fma.armA.setValue("DUAL");
			Fma.armB.setValue("LAND");
		} else if (Internal.landCondition == "SINGLE") {
			Fma.armA.setValue("SNGL");
			Fma.armB.setValue("LAND");
		} else if (Internal.landCondition == "APPR") {
			Fma.armA.setValue("APP");
			Fma.armB.setValue("ONLY");
		} else if (Input.autoLand.getBoolValue()) {
			Fma.armA.setValue("LAND");
			me.altArm();
		} else if (Output.gsArm.getBoolValue()) {
			Fma.armA.setValue("ILS");
			me.altArm();
		} else if (Output.locArm.getBoolValue()) {
			if (pts.Instrumentation.Nav.navLoc[ITAF.activeRadioSel()].getBoolValue()) {
				Fma.armA.setValue("LOC");
			} else {
				Fma.armA.setValue("VOR");
			}
			me.altArm();
		} else if (Output.lnavArm.getBoolValue()) {
			Fma.armA.setValue("FMS");
			me.altArm();
		} else {
			Fma.armA.setValue("");
			me.altArm();
		}
	},
	altArm: func() {
		if (Input.altArmed.getBoolValue()) {
			Fma.armB.setValue("ALT");
		} else {
			Fma.armB.setValue("");
		}
	},
	thr: func() {
		me.thrTemp = Output.thrMode.getValue();
		if (me.thrTemp == 3) {
			Fma.thrA.setValue("CLAMP");
			Fma.thrB.setValue("");
		} else if (me.thrTemp == 2) {
			if (pts.Options.eng.getValue() == "PW") {
				Fma.thrA.setValue("EPR");
			} else {
				Fma.thrA.setValue("N1");
			}
			Fma.thrB.setValue("");
		} else if (me.thrTemp == 1) {
			Fma.thrA.setValue("RETD");
			Fma.thrB.setValue("");
		} else if (me.thrTemp == 0) {
			Athr.modeZeroCheck(); # Handled there...
		}
	},
	# Special stuff
	locUpdate: func() {
		UpdateFma.latText = Text.lat.getValue();
		if (UpdateFma.latText == "LOC") {
			if (abs(pts.Instrumentation.Nav.headingNeedleDeflectionNorm[ITAF.activeRadioSel()].getValue()) < 0.1) {
				locUpdateT.stop();
				Fma.rollB.setValue("TRK");
			} else {
				if (Fma.rollB.getValue() != "CAP") {
					Fma.rollB.setValue("CAP");
				}
			}
		} else {
			locUpdateT.stop();
		}
	},
	gsUpdate: func() {
		UpdateFma.vertText = Text.vert.getValue();
		if (UpdateFma.vertText == "G/S") {
			if (abs(pts.Instrumentation.Nav.gsNeedleDeflectionNorm[ITAF.activeRadioSel()].getValue()) < 0.1) {
				gsUpdateT.stop();
				Fma.pitchB.setValue("TRK");
			} else {
				if (Fma.pitchB.getValue() != "CAP") {
					Fma.pitchB.setValue("CAP");
				}
			}
		} else {
			gsUpdateT.stop();
		}
	},
};

var locUpdateT = maketimer(0.5, UpdateFma.locUpdate, UpdateFma);
var gsUpdateT = maketimer(0.5, UpdateFma.gsUpdate, UpdateFma);

setlistener("/it-autoflight/input/kts-mach", func() {
	UpdateFma.thr();
}, 0, 0);

setlistener("/it-autoflight/input/kts-mach-flch", func() {
	UpdateFma.vert();
}, 0, 0);

setlistener("/instrumentation/nav[0]/nav-loc", func() {
	if (ITAF.activeRadioSel() == 0) {
		UpdateFma.arm();
		UpdateFma.lat();
	}
}, 0, 0);

setlistener("/instrumentation/nav[1]/nav-loc", func() {
	if (ITAF.activeRadioSel() == 1) {
		UpdateFma.arm();
		UpdateFma.lat();
	}
}, 0, 0);

setlistener("/it-autoflight/input/alt-armed", func() {
	UpdateFma.altArm();
}, 0, 0);

# Seperated the Autothrottle from ITAF because its very different from ITAF Core. So we do it here!
var Athr = {
	retard: 0,
	tciMode: 0,
	vmaxTypeTemp: 0,
	loop: func() {
		me.tciMode = systems.THRLIM.Limit.activeModeInt.getValue();
		Output.thrModeTemp = Output.thrMode.getValue();
		me.retard = Output.athr.getBoolValue() and Output.vert.getValue() != 7 and pts.Position.gearAglFt.getValue() <= 50 and systems.FCS.slatsCmd.getValue() >= 28 and me.tciMode != 0 and me.tciMode != 1;
		
		if (Output.thrModeTemp == 0) { # Update it as the UpdateFma only does it once
			me.modeZeroCheck();
		}
		
		if (me.tciMode == 0 or me.tciMode == 1) {
			me.toCheck();
		} else if (me.retard) {
			if (Output.thrMode.getValue() != 1) {
				Output.thrMode.setValue(1);
				UpdateFma.thr();
			}
		}
	},
	modeZeroCheck: func() {
		if (Input.kts.getValue() < Speeds.vmin.getValue()) {
			Fma.thrA.setValue("ALPHA");
			Fma.thrB.setValue("SPD");
		} else {
			Fma.thrA.setValue("SPD");
			Fma.thrB.setValue("");
		}
	},
	setMode: func(n) { # 0 Thrust, 1 Retard, 2 EPR/N1 Limit, 3 Clamp
		me.tciMode = systems.THRLIM.Limit.activeModeInt.getValue();
		
		if (me.tciMode == 0 or me.tciMode == 1) {
			me.toCheck();
		} else if (!me.retard or fgs.Output.vert.getValue() == 7) {
			Output.thrMode.setValue(n);
		}
		UpdateFma.thr();
	},
	toCheck: func() {
		if (Text.vert.getValue() == "T/O CLB") {
			if (pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 80 and pts.Position.wow.getBoolValue()) {
				if (Output.thrMode.getValue() != 2) {
					Output.thrMode.setValue(2);
					UpdateFma.thr();
				}
			} else {
				if (Output.thrMode.getValue() != 3) {
					Output.thrMode.setValue(3);
					UpdateFma.thr();
				}
			}
		} else {
			if (Output.thrMode.getValue() != 3) {
				Output.thrMode.setValue(3);
				UpdateFma.thr();
			}
		}
	},
};
