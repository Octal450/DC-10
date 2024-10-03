# McDonnell Douglas DC-10 FGCP Dialog
# Copyright (c) 2024 Josh Davidson (Octal450)

var fgcpCanvas = {
	new: func() {
		var m = {parents: [fgcpCanvas]};
		m._title = "FGCP";
		m._dialog = nil;
		m._canvas = nil;
		m._svg = nil;
		m._root = nil;
		m._svgKeys = nil;
		m._key = nil;
		m._dialogUpdate = maketimer(0.05, m, m._update);
		m._alt = 0;
		m._hdg = 0;
		m._spd = 0;
		m._vert = 0;
		
		return m;
	},
	getKeys: func() {
		return ["Ap1", "Ap2", "ApDisc", "Alt_green", "AltKnob", "AltMinus", "AltPlus", "Alt_10_disp", "Alt_100_disp", "Alt_1000_disp", "Alt_10000_disp", "Ats1", "Ats2", "AtsDisc", "Bank5", "Bank10", "Bank15", "Bank20", "Bank25", "BankLimit", "EprN1",
		"EprN1Text", "Fd1", "Fd2", "HdgKnob", "HdgMinus", "HdgPlus", "Hdg_1_disp", "Hdg_10_disp", "Hdg_100_disp", "Ias", "Ils", "Ins", "Land", "Mach", "Reset", "SpdKnob", "SpdMinus", "SpdPlus", "Spd_1_disp", "Spd_10_disp", "Spd_100_disp", "Toga", "Turb",
		"VorLoc", "VsKnob", "VsMinus", "VsPlus", "VsKnobRef", "VsKnobText"];
	},
	close: func() {
		me._dialogUpdate.stop();
		me._dialog.del();
		me._dialog = nil;
	},
	open: func() {
		if (me._dialog != nil and singleInstance) return; # Prevent more than one open
		
		me._dialog = canvas.Window.new([748, 200], "dialog", nil, 0);
		me._dialog.set("title", me._title);
		me._dialog.onClose = func() { panel2d.fgcpDialog.close(); };
		me._canvas  = me._dialog.createCanvas();
		me._root = me._canvas.createGroup();
		
		me._svg = me._root.createChild("group");
		canvas.parsesvg(me._svg, "Aircraft/DC-10/gui/canvas/fgcp.svg", {"font-mapper": font_mapper});
		
		me._svgKeys = me.getKeys();
		foreach(me._key; me._svgKeys) {
			me[me._key] = me._svg.getElementById(me._key);
		}
		
		if (pts.Options.eng.getValue() == "PW") {
			me["EprN1Text"].setText("EPR");
		}
		
		# Set up clickspots
		# Left + Right Buttons
		me["Fd1"].addEventListener("click", func(e) {
			fgs.Input.fd1.setBoolValue(!fgs.Input.fd1.getBoolValue());
		});
		me["Fd2"].addEventListener("click", func(e) {
			fgs.Input.fd2.setBoolValue(!fgs.Input.fd2.getBoolValue());
		});
		me["Turb"].addEventListener("click", func(e) {
			cockpit.ApPanel.turb();
		});
		me["Toga"].addEventListener("click", func(e) {
			cockpit.ApPanel.toga();
		});
		
		# Speed Controls
		me["Ats1"].addEventListener("click", func(e) {
			fgs.Input.athr.setBoolValue(!fgs.Input.athr.getBoolValue());
		});
		me["Ats2"].addEventListener("click", func(e) {
			fgs.Input.athr.setBoolValue(!fgs.Input.athr.getBoolValue());
		});
		me["EprN1"].addEventListener("click", func(e) {
			cockpit.ApPanel.eprN1();
		});
		me["AtsDisc"].addEventListener("click", func(e) {
			cockpit.ApPanel.atDisc();
		});
		
		# Lateral Buttons
		me["Ins"].addEventListener("click", func(e) {
			cockpit.ApPanel.ins();
		});
		me["VorLoc"].addEventListener("click", func(e) {
			cockpit.ApPanel.vorLoc();
		});
		me["Ils"].addEventListener("click", func(e) {
			cockpit.ApPanel.ils();
		});
		
		# Vertical Buttons
		me["Reset"].addEventListener("click", func(e) {
			cockpit.ApPanel.reset();
		});
		me["Ias"].addEventListener("click", func(e) {
			cockpit.ApPanel.ias();
		});
		me["Mach"].addEventListener("click", func(e) {
			cockpit.ApPanel.mach();
		});
		me["Land"].addEventListener("click", func(e) {
			cockpit.ApPanel.land();
		});
		
		# AP Switches
		me["Ap1"].addEventListener("click", func(e) {
			if (e.button == 1) {
				cockpit.ApPanel.apFgs1(-1);
			} else if (e.button == 0) {
				cockpit.ApPanel.apFgs1(1);
			}
		});
		me["Ap2"].addEventListener("click", func(e) {
			if (e.button == 1) {
				cockpit.ApPanel.apFgs2(-1);
			} else if (e.button == 0) {
				cockpit.ApPanel.apFgs2(1);
			}
		});
		me["ApDisc"].addEventListener("click", func(e) {
			cockpit.ApPanel.apDisc();
		});
		
		# Speed Knob
		me["SpdKnob"].addEventListener("click", func(e) {
			cockpit.ApPanel.spdPull();
		});
		me["SpdKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(10 * e.deltaY);
			} else {
				cockpit.ApPanel.spdAdjust(e.deltaY);
			}
		});
		me["SpdMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(-10);
			} else {
				cockpit.ApPanel.spdAdjust(-1);
			}
		});
		me["SpdPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(10);
			} else {
				cockpit.ApPanel.spdAdjust(1);
			}
		});
		
		# Heading Knob
		me["HdgKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				cockpit.ApPanel.hdgPull();
			} else if (e.button == 0) {
				cockpit.ApPanel.hdgPush();
			}
		});
		me["HdgKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(10 * e.deltaY);
			} else {
				cockpit.ApPanel.hdgAdjust(e.deltaY);
			}
		});
		me["HdgMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(-10);
			} else {
				cockpit.ApPanel.hdgAdjust(-1);
			}
		});
		me["HdgPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(10);
			} else {
				cockpit.ApPanel.hdgAdjust(1);
			}
		});
		
		# Bank Limit
		me["Bank5"].addEventListener("click", func(e) {
			fgs.Input.bankLimitSw.setValue(0);
		});
		me["Bank10"].addEventListener("click", func(e) {
			fgs.Input.bankLimitSw.setValue(1);
		});
		me["Bank15"].addEventListener("click", func(e) {
			fgs.Input.bankLimitSw.setValue(2);
		});
		me["Bank20"].addEventListener("click", func(e) {
			fgs.Input.bankLimitSw.setValue(3);
		});
		me["Bank25"].addEventListener("click", func(e) {
			fgs.Input.bankLimitSw.setValue(4);
		});
		
		# VS Knob
		me["VsKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(-10 * e.deltaY); # Inverted
			} else {
				cockpit.ApPanel.vsAdjust(-1 * e.deltaY); # Inverted
			}
		});
		me["VsMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(-10);
			} else {
				cockpit.ApPanel.vsAdjust(-1);
			}
		});
		me["VsPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(10);
			} else {
				cockpit.ApPanel.vsAdjust(1);
			}
		});
		
		# Altitude Knob
		me["AltKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				cockpit.ApPanel.altPull();
			} else if (e.button == 0) {
				cockpit.ApPanel.altPush();
			}
		});
		me["AltKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(10 * e.deltaY);
			} else {
				cockpit.ApPanel.altAdjust(e.deltaY);
			}
		});
		me["AltMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(-10);
			} else {
				cockpit.ApPanel.altAdjust(-1);
			}
		});
		me["AltPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(10);
			} else {
				cockpit.ApPanel.altAdjust(1);
			}
		});
		
		me._update();
		me._dialogUpdate.start();
	},
	_update: func() {
		# Speed
		me._spd = fgs.Input.kts.getValue();
		me["Spd_1_disp"].setText(right(sprintf("%02d", me._spd), 1));
		me["Spd_10_disp"].setText(right(sprintf("%02d", me._spd / 10), 1));
		me["Spd_100_disp"].setText(right(sprintf("%02d", me._spd / 100), 1));
		
		# Heading
		me._hdg = fgs.Input.hdg.getValue();
		me["Hdg_1_disp"].setText(right(sprintf("%02d", me._hdg), 1));
		me["Hdg_10_disp"].setText(right(sprintf("%02d", me._hdg / 10), 1));
		me["Hdg_100_disp"].setText(right(sprintf("%02d", me._hdg / 100), 1));
		
		# Bank Limit
		me["BankLimit"].setRotation(((fgs.Input.bankLimitSw.getValue() * 30) - 60) * D2R);
		
		# VS Wheel
		me["VsKnobRef"].setTranslation(0, ((fgs.Input.vsWheel.getValue() / 2000) * 30) * (1 - (abs(fgs.Input.vsWheel.getValue()) / 16666)));
		
		# Altitude
		me._alt = fgs.Input.alt.getValue();
		me["Alt_100_disp"].setText(right(sprintf("%02d", me._alt / 100), 1));
		me["Alt_1000_disp"].setText(right(sprintf("%02d", me._alt / 1000), 1));
		if (me._alt < 10000) {
			me["Alt_10000_disp"].hide();
			me["Alt_green"].show();
		} else {
			me["Alt_10000_disp"].setText(right(sprintf("%02d", me._alt / 10000), 1));
			me["Alt_10000_disp"].show();
			me["Alt_green"].hide();
		}
		
		# On/Off Controls
		me["Fd1"].setRotation(fgs.Output.fd1.getValue() * 180 * D2R);
		me["Fd2"].setRotation(fgs.Output.fd2.getValue() * 180 * D2R);
		
		me["Ats1"].setTranslation(0, fgs.Output.athr.getBoolValue() * -49.427);
		me["Ats2"].setTranslation(0, fgs.Output.athr.getBoolValue() * -49.427);
		
		me["Ap1"].setTranslation(0, fgs.Input.fgs1Sel.getValue() * -22.7135); # Property is input/output combo
		me["Ap2"].setTranslation(0, fgs.Input.fgs2Sel.getValue() * -22.7135); # Property is input/output combo
	},
};

var fgcpDialog = fgcpCanvas.new();
