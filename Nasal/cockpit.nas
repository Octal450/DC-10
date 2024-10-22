# McDonnell Douglas DC-10 Cockpit Controls
# Copyright (c) 2024 Josh Davidson (Octal450)

# Resets buttons to the default values
var variousReset = func() {
	pts.Controls.Flight.dialAFlap.setValue(15); 
	#pts.Controls.Lighting.beacon.setBoolValue(0);
	#pts.Controls.Lighting.emerLt.setValue(0);
	#pts.Controls.Lighting.landingLightL.setValue(0);
	#pts.Controls.Lighting.landingLightN.setValue(0);
	#pts.Controls.Lighting.landingLightR.setValue(0);
	#pts.Controls.Lighting.logoLights.setBoolValue(0);
	#pts.Controls.Lighting.navLights.setBoolValue(0);
	#pts.Controls.Lighting.strobe.setBoolValue(0);
	pts.Controls.Switches.adgHandle.setValue(0);
	pts.Controls.Switches.minimums.setValue(200);
	pts.Controls.Switches.noSmokingSign.setValue(1); # Smoking is bad!
	pts.Controls.Switches.seatbeltSign.setValue(0);
}

var ApPanel = {
	hdgTemp: 0,
	latTemp: 0,
	ktsTemp: 0,
	ktsFlchTemp: 0,
	machTemp: 0,
	machFlchTemp: 0,
	pitchTemp: 0,
	vertTemp: 0,
	vsTemp: 0,
	apDisc: func() {
		fgs.killApWarn();
		if (fgs.Output.ap1.getBoolValue()) {
			fgs.ITAF.ap1Master(0);
		}
		if (fgs.Output.ap2.getBoolValue()) {
			fgs.ITAF.ap2Master(0);
		}
	},
	atDisc: func() {
		fgs.killAtsWarn();
		if (fgs.Output.athr.getBoolValue()) {
			fgs.ITAF.athrMaster(0);
		}
	},
	apFgs1: func(d) {
		if (d == 1) {
			fgs.Input.fgs1SelTemp = fgs.Input.fgs1Sel.getValue();
			if (fgs.Input.fgs1SelTemp < 2) {
				fgs.Input.fgs1Sel.setValue(fgs.Input.fgs1SelTemp + 1);
			} else {
				fgs.Input.fgs1Sel.setValue(0);
			}
		} else if (d == -1) {
			fgs.Input.fgs1Sel.setValue(0);
		}
	},
	apFgs2: func(d) {
		if (d == 1) {
			fgs.Input.fgs2SelTemp = fgs.Input.fgs2Sel.getValue();
			if (fgs.Input.fgs2SelTemp < 2) {
				fgs.Input.fgs2Sel.setValue(fgs.Input.fgs2SelTemp + 1);
			} else {
				fgs.Input.fgs2Sel.setValue(0);
			}
		} else if (d == -1) {
			fgs.Input.fgs2Sel.setValue(0);
		}
	},
	spdPull: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			me.vertTemp = fgs.Output.vert.getValue();
			fgs.Athr.setMode(0); # Thrust
			if (me.vertTemp == 4 or me.vertTemp == 7) {
				fgs.Input.vert.setValue(1);
			}
		}
	},
	spdAdjust: func(d) {
		me.ktsTemp = fgs.Input.kts.getValue() + d;
		if (me.ktsTemp < 100) {
			fgs.Input.kts.setValue(100);
		} else if (me.ktsTemp > 380) {
			fgs.Input.kts.setValue(380);
		} else {
			fgs.Input.kts.setValue(me.ktsTemp);
		}
	},
	eprN1: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Athr.setMode(2); # EPR/N1 Limit
		}
	},
	hdgPush: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.lat.setValue(3);
		}
	},
	hdgPull: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.lat.setValue(0);
		}
	},
	hdgAdjust: func(d) {
		me.hdgTemp = fgs.Input.hdg.getValue() + d;
		if (me.hdgTemp < 0.5) {
			fgs.Input.hdg.setValue(me.hdgTemp + 360);
		} else if (me.hdgTemp >= 360.5) {
			fgs.Input.hdg.setValue(me.hdgTemp - 360);
		} else {
			fgs.Input.hdg.setValue(me.hdgTemp);
		}
	},
	fms: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.lat.setValue(1);
		}
	},
	vorLoc: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.lat.setValue(2);
		}
	},
	ils: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.ITAF.updateAutoLand(0);
			fgs.Input.vert.setValue(2);
		}
	},
	vsAdjust: func(d) {
		me.vertTemp = fgs.Output.vert.getValue();
		if (me.vertTemp == 1) {
			me.vsTemp = fgs.Input.vs.getValue() + (d * 100);
			if (me.vsTemp < -6000) {
				fgs.Input.vs.setValue(-6000);
			} else if (me.vsTemp > 6000) {
				fgs.Input.vs.setValue(6000);
			} else {
				fgs.Input.vs.setValue(me.vsTemp);
			}
		} else {
			fgs.Input.vert.setValue(1);
		}
	},
	altPush: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.altArmed.setBoolValue(0);
		}
	},
	altPull: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			me.vertTemp = fgs.Output.vert.getValue();
			if (me.vertTemp != 2 and me.vertTemp != 6) {
				fgs.Input.altArmed.setBoolValue(1);
			}
		}
	},
	altAdjust: func(d) {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.altArmed.setBoolValue(0);
			systems.WARNINGS.altitudeAlertCaptured.setValue(0); # Reset out of captured state
			if (systems.WARNINGS.altitudeAlert.getValue() == 2) systems.WARNINGS.altitudeAlert.setValue(0); # Cancel altitude alert deviation alarm
		}
		
		me.altTemp = fgs.Input.alt.getValue();
		me.altTemp = math.round(me.altTemp + (d * 100), 100);
		if (me.altTemp < 0) {
			fgs.Input.alt.setValue(0);
		} else if (me.altTemp > 49900) {
			fgs.Input.alt.setValue(49900);
		} else {
			fgs.Input.alt.setValue(me.altTemp);
		}
	},
	reset: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			systems.WARNINGS.altitudeAlertCaptured.setValue(0); # Reset out of captured state
			if (systems.WARNINGS.altitudeAlert.getValue() == 2) systems.WARNINGS.altitudeAlert.setValue(0); # Cancel altitude alert deviation alarm
		}
	},
	ias: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.ktsMachFlch.setBoolValue(0);
			if (fgs.Output.vert.getValue() != 4) {
				fgs.Input.vert.setValue(4);
			}
		}
	},
	mach: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.ktsMachFlch.setBoolValue(1);
			if (fgs.Output.vert.getValue() != 4) {
				fgs.Input.vert.setValue(4);
			}
		}
	},
	land: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			if ((fgs.Output.ap1Temp == 1 and fgs.Input.fgs1Sel.getValue() == 2) or (fgs.Output.ap2Temp == 1 and fgs.Input.fgs2Sel.getValue() == 2)) {
				fgs.ITAF.updateAutoLand(1);
				fgs.Input.vert.setValue(2);
			}
		}
	},
	turb: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			if (fgs.Input.fgs1Sel.getValue() == 2) {
				fgs.Input.fgs1Sel.setValue(1);
				# Sound AP alarm
			}
			if (fgs.Input.fgs2Sel.getValue() == 2) {
				fgs.Input.fgs2Sel.setValue(1);
				# Sound AP alarm
			}
			fgs.Input.vert.setValue(9);
		}
	},
	toga: func() {
		if (systems.ELECTRICAL.Generic.fgcp.getValue() >= 24) {
			fgs.Input.toga.setValue(1);
		}
	},
};
