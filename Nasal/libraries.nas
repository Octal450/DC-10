# McDonnell Douglas DC-10 Main Libraries
# Copyright (c) 2024 Josh Davidson (Octal450)

print("------------------------------------------------");
print("Copyright (c) 2019-2024 Josh Davidson (Octal450)");
print("------------------------------------------------");

setprop("/sim/menubar/default/menu[0]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[2]/enabled", 0);
setprop("/sim/menubar/default/menu[3]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[8]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[9]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[10]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[11]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[12]/enabled", 0);
setprop("/sim/multiplay/visibility-range-nm", 130);

var initDone = 0;
var systemsInit = func {
	systems.APU.init();
	systems.ELEC.init();
	systems.ENGINE.init();
	systems.FCC.init();
	systems.FUEL.init();
	systems.GEAR.init();
	systems.HYD.init();
	systems.THRLIM.init();
	fgs.ITAF.init();
	cockpit.variousReset();
}

var fdmInit = setlistener("sim/signals/fdm-initialized", func {
	acconfig.SYSTEM.fdmInit();
	systemsInit();
	systemsLoop.start();
	slowLoop.start();
	canvas_fma.init();
	acconfig.SYSTEM.finalInit();
	removelistener(fdmInit);
	initDone = 1;
});

var systemsLoop = maketimer(0.1, func {
	SHAKE.loop();
	
	if (pts.Sim.Replay.replayState.getBoolValue()) {
		pts.Controls.Flight.wingflexEnable.setBoolValue(0);
	} else {
		pts.Controls.Flight.wingflexEnable.setBoolValue(1);
	}
	
	pts.Services.Chocks.enableTemp = pts.Services.Chocks.enable.getBoolValue();
	pts.Velocities.groundspeedKtTemp = pts.Velocities.groundspeedKt.getValue();
	if ((pts.Velocities.groundspeedKtTemp >= 2 or !pts.Fdm.JSBSim.Position.wow.getBoolValue()) and pts.Services.Chocks.enableTemp) {
		pts.Services.Chocks.enable.setBoolValue(0);
	}
	
	if ((pts.Velocities.groundspeedKtTemp >= 2 or (!systems.GEAR.Switch.brakeParking.getBoolValue() and !pts.Services.Chocks.enableTemp)) and !acconfig.SYSTEM.autoConfigRunning.getBoolValue()) {
		if (systems.ELEC.Switch.groundCart.getBoolValue()) {
			systems.ELEC.Switch.groundCart.setBoolValue(0);
		}
		#if (systems.PNEU.Switch.groundAir.getBoolValue()) {
		#	systems.PNEU.Switch.groundAir.setBoolValue(0);
		#}
	}
});

var onceEng = pts.Options.eng.getValue();
var slowLoop = maketimer(1, func() {
	if (pts.Fdm.JSBSim.Engine.Limit.overspeed.getBoolValue()) {
		if (onceEng == "PW") {
			gui.popupTip("You are overspeeding the engines! Reduce power to below the EPR limit!");
		} else {
			gui.popupTip("You are overspeeding the engines! Reduce power to below the N1 limit!");
		}
	}
	
	if (acconfig.SYSTEM.Error.active.getBoolValue()) {
		systemsInit();
	}
});

canvas.Text._lastText = canvas.Text["_lastText"];
canvas.Text.setText = func(text) {
	if (text == me._lastText and text != nil and size(text) == size(me._lastText)) {
		return me;
	}
	me._lastText = text;
	me.set("text", typeof(text) == "scalar" ? text : "");
};
canvas.Element._lastVisible = nil;
canvas.Element.show = func() {
	if (1 == me._lastVisible) {
		return me;
	}
	me._lastVisible = 1;
	me.setBool("visible", 1);
};
canvas.Element.hide = func() {
	if (0 == me._lastVisible) {
		return me;
	}
	me._lastVisible = 0;
	me.setBool("visible", 0);
};
canvas.Element.setVisible = func(vis) {
	if (vis == me._lastVisible) {
		return me;
	}
	me._lastVisible = vis;
	me.setBool("visible", vis);
};

# Custom controls.nas overrides
controls.autopilotDisconnect = func() {
	cockpit.ApPanel.apDisc();
}

controls.reverserTogglePosition = func() {
	systems.toggleRevThrust();
}

controls.flapsDown = func(step) {
	pts.Controls.Flight.flapsTemp = pts.Controls.Flight.flaps.getValue();
	if (step == 1) {
		if (pts.Controls.Flight.flapsTemp < 0.2) {
			pts.Controls.Flight.flaps.setValue(0.2);
		} else if (pts.Controls.Flight.flapsTemp < 0.36) {
			pts.Controls.Flight.flaps.setValue(0.36);
		} else if (pts.Controls.Flight.flapsTemp < 0.52) {
			pts.Controls.Flight.flaps.setValue(0.52);
		} else if (pts.Controls.Flight.flapsTemp < 0.68) {
			pts.Controls.Flight.flaps.setValue(0.68);
		} else if (pts.Controls.Flight.flapsTemp < 0.84) {
			pts.Controls.Flight.flaps.setValue(0.84);
		}
	} else if (step == -1) {
		if (pts.Controls.Flight.flapsTemp > 0.68) {
			pts.Controls.Flight.flaps.setValue(0.68);
		} else if (pts.Controls.Flight.flapsTemp > 0.52) {
			pts.Controls.Flight.flaps.setValue(0.52);
		} else if (pts.Controls.Flight.flapsTemp > 0.36) {
			pts.Controls.Flight.flaps.setValue(0.36);
		} else if (pts.Controls.Flight.flapsTemp > 0.2) {
			pts.Controls.Flight.flaps.setValue(0.2);
		} else if (pts.Controls.Flight.flapsTemp > 0) {
			pts.Controls.Flight.flaps.setValue(0);
		}
	}
}

var leverCockpit = 3;
controls.gearDown = func(d) { # Requires a mod-up
	pts.Fdm.JSBSim.Position.wowTemp = pts.Fdm.JSBSim.Position.wow.getBoolValue();
	leverCockpit = systems.GEAR.Switch.leverCockpit.getValue();
	if (d < 0) {
		if (pts.Fdm.JSBSim.Position.wowTemp) {
			if (leverCockpit == 3) {
				systems.GEAR.Switch.leverCockpit.setValue(2);
			} else if (leverCockpit == 0) {
				systems.GEAR.Switch.leverCockpit.setValue(1);
			}
		} else {
			systems.GEAR.Switch.leverCockpit.setValue(0);
		}
	} else if (d > 0) {
		if (pts.Fdm.JSBSim.Position.wowTemp) {
			if (leverCockpit == 3) {
				systems.GEAR.Switch.leverCockpit.setValue(2);
			} else if (leverCockpit == 0) {
				systems.GEAR.Switch.leverCockpit.setValue(1);
			}
		} else {
			systems.GEAR.Switch.leverCockpit.setValue(3);
		}
	} else {
		if (leverCockpit == 2) {
			systems.GEAR.Switch.leverCockpit.setValue(3);
		} else if (leverCockpit == 1) {
			systems.GEAR.Switch.leverCockpit.setValue(0);
		}
	}
}

controls.gearDownSmart = func(d) { # Used by cockpit, requires a mod-up
	if (d) {
		if (systems.GEAR.Switch.leverCockpit.getValue() >= 2) {
			controls.gearDown(-1);
		} else {
			controls.gearDown(1);
		}
	} else {
		controls.gearDown(0);
	}
}

controls.gearToggle = func() {
	if (!pts.Fdm.JSBSim.Position.wow.getBoolValue()) {
		if (systems.GEAR.Switch.leverCockpit.getValue() >= 2) {
			systems.GEAR.Switch.leverCockpit.setValue(0);
		} else {
			systems.GEAR.Switch.leverCockpit.setValue(3);
		}
	} else {
		systems.GEAR.Switch.leverCockpit.setValue(3);
	}
}

controls.gearTogglePosition = func(d) {
	if (d) {
		controls.gearToggle();
	}
}

controls.stepSpoilers = func(step) {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	if (step == 1) {
		deploySpeedbrake();
	} else if (step == -1) {
		retractSpeedbrake();
	}
}

var speedbrakeKey = func() {
	if (pts.Controls.Flight.speedbrakeArm.getBoolValue()) {
		pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	} else {
		pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
		if (pts.Gear.wow[0].getBoolValue()) {
			if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
				pts.Controls.Flight.speedbrake.setValue(0.2);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
				pts.Controls.Flight.speedbrake.setValue(0.4);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.6) {
				pts.Controls.Flight.speedbrake.setValue(0.6);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) {
				pts.Controls.Flight.speedbrake.setValue(0.8);
			} else {
				pts.Controls.Flight.speedbrake.setValue(0);
			}
		} else {
			if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
				pts.Controls.Flight.speedbrake.setValue(0.2);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
				pts.Controls.Flight.speedbrake.setValue(0.4);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) { # Not 0.6!
				pts.Controls.Flight.speedbrake.setValue(0.8); # Not 0.6!
			} else {
				pts.Controls.Flight.speedbrake.setValue(0);
			}
		}
	}
}

var deploySpeedbrake = func() {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
	if (pts.Gear.wow[0].getBoolValue()) {
		if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.6) {
			pts.Controls.Flight.speedbrake.setValue(0.6);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) {
			pts.Controls.Flight.speedbrake.setValue(0.8);
		}
	} else {
		if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) { # Not 0.6!
			pts.Controls.Flight.speedbrake.setValue(0.8); # Not 0.6!
		}
	}
}

var retractSpeedbrake = func() {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
	if (pts.Gear.wow[0].getBoolValue()) {
		if (pts.Controls.Flight.speedbrakeTemp > 0.6) {
			pts.Controls.Flight.speedbrake.setValue(0.6);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0) {
			pts.Controls.Flight.speedbrake.setValue(0);
		}
	} else {
		if (pts.Controls.Flight.speedbrakeTemp > 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0) {
			pts.Controls.Flight.speedbrake.setValue(0);
		}
	}
}

var delta = 0;
var output = 0;
var slewProp = func(prop, delta) {
	delta *= pts.Sim.Time.deltaRealtimeSec.getValue();
	output = props.globals.getNode(prop).getValue() + delta;
	props.globals.getNode(prop).setValue(output);
	return output;
}

controls.elevatorTrim = func(d) {
	if (fgs.Output.ap1.getBoolValue()) {
		fgs.ITAF.ap1Master(0);
	}
	if (fgs.Output.ap2.getBoolValue()) {
		fgs.ITAF.ap2Master(0);
	}
	if (systems.HYD.Psi.sys1.getValue() >= 2200 or systems.HYD.Psi.sys3.getValue() >= 2200) {
		slewProp("/controls/flight/elevator-trim", d * 0.0193548); # 0.0162 is the rate in JSB normalized (0.3 / 15.5)
	}
}

setlistener("/controls/flight/elevator-trim", func() {
	if (pts.Controls.Flight.elevatorTrim.getValue() > 0.066667) {
		pts.Controls.Flight.elevatorTrim.setValue(0.066667);
	}
}, 0, 0);

# Override FG's generic brake
controls.applyBrakes = func(v, which = 0) { # No interpolate, that's bad, we will apply rate-limit in JSBSim
	if (which <= 0) {
		systems.GEAR.Switch.brakeLeft.setValue(v);
	}
	if (which >= 0) {
		systems.GEAR.Switch.brakeRight.setValue(v);
	}
}

if (pts.Controls.Flight.autoCoordination.getBoolValue()) {
	pts.Controls.Flight.autoCoordination.setBoolValue(0);
	pts.Controls.Flight.aileronDrivesTiller.setBoolValue(1);
} else {
	pts.Controls.Flight.aileronDrivesTiller.setBoolValue(0);
}

setlistener("/controls/flight/auto-coordination", func() {
	pts.Controls.Flight.autoCoordination.setBoolValue(0);
	print("System: Auto Coordination has been turned off as it is not compatible with the flight control system of this aircraft.");
	screen.log.write("Auto Coordination has been disabled as it is not compatible with the flight control system of this aircraft", 1, 0, 0);
});

# Shaking Logic
var SHAKE = {
	force: 0,
	rollspeedMs: [0, 0, 0],
	wow: [0, 0, 0],
	loop: func() {
		me.rollspeedMs[0] = pts.Gear.rollspeedMs[0].getValue();
		me.rollspeedMs[1] = pts.Gear.rollspeedMs[1].getValue();
		me.rollspeedMs[2] = pts.Gear.rollspeedMs[2].getValue();
		me.wow[0] = pts.Gear.wow[0].getBoolValue();
		me.wow[1] = pts.Gear.wow[1].getBoolValue();
		me.wow[2] = pts.Gear.wow[2].getBoolValue();
		
		if (pts.Velocities.groundspeedKt.getValue() >= 1 and (me.wow[0] or me.wow[1] or me.wow[2])) {
			if (me.wow[0]) {
				me.force = me.rollspeedMs[0] / 94000;
			} else {
				me.force = math.max(me.rollspeedMs[1], me.rollspeedMs[2]) / 188000;
			}
			
			interpolate(pts.Systems.Shake.shaking, 0, 0.03);
			settimer(func() {
				interpolate(pts.Systems.Shake.shaking, me.force * 1.5, 0.03); 
			}, 0.5);
		} else {
			pts.Systems.Shake.shaking.setBoolValue(0);
		}	    
	},
};

# Sounds
var Sound = {
	btn1: func() {
		if (pts.Sim.Sound.btn1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn1.setBoolValue(0);
		}, 0.2);
	},
	btn3: func() {
		if (pts.Sim.Sound.btn3.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn3.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn3.setBoolValue(0);
		}, 0.2);
	},
	knb1: func() {
		if (pts.Sim.Sound.knb1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.knb1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.knb1.setBoolValue(0);
		}, 0.2);
	},
	ohBtn: func() {
		if (pts.Sim.Sound.btn2.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn2.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn2.setBoolValue(0);
		}, 0.2);
	},
	switch1: func() {
		if (pts.Sim.Sound.switch1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.switch1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.switch1.setBoolValue(0);
		}, 0.2);
	},
};

setlistener("/controls/flight/flaps-input", func() {
	if (pts.Sim.Sound.flapsClick.getBoolValue()) {
		return;
	}
	pts.Sim.Sound.flapsClick.setBoolValue(1);
	settimer(func() {
		pts.Sim.Sound.flapsClick.setBoolValue(0);
	}, 0.4);
}, 0, 0);

setlistener("/controls/switches/seatbelt-sign-status", func() {
	if (pts.Sim.Sound.seatbeltSign.getBoolValue()) {
		return;
	}
	if (systems.ELEC.Generic.efis.getValue() >= 25) {
		pts.Sim.Sound.noSmokingSignInhibit.setBoolValue(1); # Prevent no smoking sound from playing at same time
		pts.Sim.Sound.seatbeltSign.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.seatbeltSign.setBoolValue(0);
			pts.Sim.Sound.noSmokingSignInhibit.setBoolValue(0);
		}, 2);
	}
}, 0, 0);

setlistener("/controls/switches/no-smoking-sign-status", func() {
	if (pts.Sim.Sound.noSmokingSign.getBoolValue()) {
		return;
	}
	if (systems.ELEC.Generic.efis.getValue() >= 25 and !pts.Sim.Sound.noSmokingSignInhibit.getBoolValue()) {
		pts.Sim.Sound.noSmokingSign.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.noSmokingSign.setBoolValue(0);
		}, 1);
	}
}, 0, 0);
