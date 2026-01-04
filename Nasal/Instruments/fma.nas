# McDonnell Douglas DC-10 FMA
# Copyright (c) 2026 Josh Davidson (Octal450)

var fmaL = nil;
var fmaLDisplay = nil;
var fmaR = nil;
var fmaRDisplay = nil;

var Modes = { # 0 thrust, 1 arm, 2 roll, 3 pitch
	line1: [fgs.Fma.thrA, fgs.Fma.armA, fgs.Fma.rollA, fgs.Fma.pitchA],
	line2: [fgs.Fma.thrB, fgs.Fma.armB, fgs.Fma.rollB, fgs.Fma.pitchB],
};

var Value = {
	apOn: 0,
	atsOn: 0,
	fdOn: 0,
	hideScreen: [[0, 0, 0, 0], [0, 0, 0, 0]],
	line1: ["", "", "", ""],
	line1Old: [["", "", "", ""], ["", "", "", ""]],
	line2: ["", "", "", ""],
	line2Old: [["", "", "", ""], ["", "", "", ""]],
	window: ["Thr", "Arm", "Roll", "Pitch"],
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "Alata.ttf";
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
		}
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		fmaL.update();
		fmaR.update();
	},
	updateBase: func(n) {
		Value.apOn = (fgs.Output.ap1.getBoolValue() and fgs.Input.fgs1Sel.getValue() == 2) or (fgs.Output.ap2.getBoolValue() and fgs.Input.fgs2Sel.getValue() == 2);
		Value.atsOn = fgs.Output.athr.getBoolValue();
		if (n == 0) Value.fdOn = fgs.Output.fd1.getBoolValue();
		if (n == 1) Value.fdOn = fgs.Output.fd2.getBoolValue();
		
		if (systems.ELECTRICAL.Outputs.fma[n].getValue() >= 24) {
			for (var w = 0; w <= 3; w = w + 1) {
				Value.line1[w] = Modes.line1[w].getValue();
				Value.line2[w] = Modes.line2[w].getValue();
			}
			
			if (Value.atsOn) {
				if (Value.line1[0] != Value.line1Old[n][0] or Value.line2[0] != Value.line2Old[n][0]) {
					Value.line1Old[n][0] = Value.line1[0];
					Value.line2Old[n][0] = Value.line2[0];
					Value.hideScreen[n][0] = 1;
				}
				
				me["Thr"].show();
			} else {
				me["Thr"].hide();
				Value.hideScreen[n][0] = 1;
			}
			
			if (Value.apOn or Value.fdOn) {
				for (var w = 1; w <= 3; w = w + 1) {
					if (Value.line1[w] != Value.line1Old[n][w] or Value.line2[w] != Value.line2Old[n][w]) {
						Value.line1Old[n][w] = Value.line1[w];
						Value.line2Old[n][w] = Value.line2[w];
						Value.hideScreen[n][w] = 1;
					}
					
					if (w == 1) {
						if (Value.line1[1] == "DUAL") {
							me["ArmLine1"].setColor(0, 1, 0);
							me["ArmLine2"].setColor(0, 1, 0);
						} else {
							me["ArmLine1"].setColor(1, 0.5333, 0.0392);
							me["ArmLine2"].setColor(1, 0.5333, 0.0392);
						}
					}
				}
				
				me["Arm"].show();
				me["Pitch"].show();
				me["Roll"].show();
			} else {
				me["Arm"].hide();
				me["Pitch"].hide();
				me["Roll"].hide();
				Value.hideScreen[n][1] = 1;
				Value.hideScreen[n][2] = 1;
				Value.hideScreen[n][3] = 1;
			}
		} else {
			me["Arm"].hide();
			me["Pitch"].hide();
			me["Roll"].hide();
			me["Thr"].hide();
			Value.hideScreen[n][0] = 1;
			Value.hideScreen[n][1] = 1;
			Value.hideScreen[n][2] = 1;
			Value.hideScreen[n][3] = 1;
		}
		
		# Last, resets screens to be visible next fresh
		for (var w = 0; w <= 3; w = w + 1) {
			if (Value.line2[w] == "") {
				me[Value.window[w] ~ "Line1"].setTranslation(0, 28);
			} else {
				me[Value.window[w] ~ "Line1"].setTranslation(0, 0);
			}
			
			if (Value.hideScreen[n][w]) {
				me[Value.window[w] ~ "Line1"].setText("");
			} else {
				me[Value.window[w] ~ "Line1"].setText(Value.line1[w]);
			}
			
			if (Value.line1[w] == "") {
				me[Value.window[w] ~ "Line2"].setTranslation(0, -28);
			} else {
				me[Value.window[w] ~ "Line2"].setTranslation(0, 0);
			}
			
			if (Value.hideScreen[n][w]) {
				me[Value.window[w] ~ "Line2"].setText("");
			} else {
				me[Value.window[w] ~ "Line2"].setText(Value.line2[w]);
			}
			
			if (Value.hideScreen[n][w]) {
				Value.hideScreen[n][w] = 0;
			}
		}
	},
};

var canvasFmaL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasFmaL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Arm", "ArmLine1", "ArmLine2", "Pitch", "PitchLine1", "PitchLine2", "Roll", "RollLine1", "RollLine2", "Thr", "ThrLine1", "ThrLine2"];
	},
	update: func() {
		me.updateBase(0);
	},
};

var canvasFmaR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasFmaR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Arm", "ArmLine1", "ArmLine2", "Pitch", "PitchLine1", "PitchLine2", "Roll", "RollLine1", "RollLine2", "Thr", "ThrLine1", "ThrLine2"];
	},
	update: func() {
		me.updateBase(1);
	},
};

var setup = func() {
	fmaLDisplay = canvas.new({
		"name": "fmaL",
		"size": [825, 128],
		"view": [825, 128],
		"mipmapping": 1
	});
	fmaRDisplay = canvas.new({
		"name": "fmaR",
		"size": [825, 128],
		"view": [825, 128],
		"mipmapping": 1
	});
	
	fmaLDisplay.addPlacement({"node": "fma1.screen"});
	fmaRDisplay.addPlacement({"node": "fma2.screen"});
	
	var fmaLGroup = fmaLDisplay.createGroup();
	var fmaRGroup = fmaRDisplay.createGroup();
	
	fmaL = canvasFmaL.new(fmaLGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	fmaR = canvasFmaR.new(fmaRGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	
	update.start();
}

var update = maketimer(0.25, func() {
	canvasBase.update();
});
