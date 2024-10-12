# McDonnell Douglas DC-10 FMA
# Copyright (c) 2024 Josh Davidson (Octal450)

var armL = nil;
var armLDisplay = nil;
var armR = nil;
var armRDisplay = nil;
var pitchL = nil;
var pitchLDisplay = nil;
var pitchR = nil;
var pitchRDisplay = nil;
var rollL = nil;
var rollLDisplay = nil;
var rollR = nil;
var rollRDisplay = nil;
var thrL = nil;
var thrLDisplay = nil;
var thrR = nil;
var thrRDisplay = nil;

var Modes = { # 0 thrust, 1 arm, 2 roll, 3 pitch
	Line1: [fgs.Fma.thrA, fgs.Fma.armA, fgs.Fma.rollA, fgs.Fma.pitchA],
	Line2: [fgs.Fma.thrB, fgs.Fma.armB, fgs.Fma.rollB, fgs.Fma.pitchB],
};

var Value = {
	apOn: 0,
	atsOn: 0,
	hideScreen: [[0, 0, 0, 0], [0, 0, 0, 0]],
	line1: ["", "", "", ""],
	line1Old: [["", "", "", ""], ["", "", "", ""]],
	line2: ["", "", "", ""],
	line2Old: [["", "", "", ""], ["", "", "", ""]],
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
	setup: func() {
	},
	update: func() {
		Value.apOn = (fgs.Output.ap1.getBoolValue() and fgs.Input.fgs1Sel.getValue() == 2) or (fgs.Output.ap2.getBoolValue() and fgs.Input.fgs2Sel.getValue() == 2);
		Value.atsOn = fgs.Output.athr.getBoolValue();
		
		if (systems.ELECTRICAL.Generic.fma[0].getValue() >= 24) {
			if (Value.atsOn) {
				thrL.update();
				thrL.page.show();
			} else {
				thrL.page.hide();
				Value.hideScreen[0][0] = 1;
			}
			
			if (fgs.Output.fd1.getBoolValue() or Value.apOn) {
				armL.update();
				armL.page.show();
				pitchL.update();
				pitchL.page.show();
				rollL.update();
				rollL.page.show();
			} else {
				armL.page.hide();
				pitchL.page.hide();
				rollL.page.hide();
				Value.hideScreen[0][1] = 1;
				Value.hideScreen[0][2] = 1;
				Value.hideScreen[0][3] = 1;
			}
		} else {
			armL.page.hide();
			pitchL.page.hide();
			rollL.page.hide();
			thrL.page.hide();
			Value.hideScreen[0][0] = 1;
			Value.hideScreen[0][1] = 1;
			Value.hideScreen[0][2] = 1;
			Value.hideScreen[0][3] = 1;
		}
		
		if (systems.ELECTRICAL.Generic.fma[1].getValue() >= 24) {
			if (Value.atsOn) {
				thrR.update();
				thrR.page.show();
			} else {
				thrR.page.hide();
				Value.hideScreen[1][0] = 1;
			}
			
			if (fgs.Output.fd2.getBoolValue() or Value.apOn) {
				armR.update();
				armR.page.show();
				pitchR.update();
				pitchR.page.show();
				rollR.update();
				rollR.page.show();
			} else {
				armR.page.hide();
				pitchR.page.hide();
				rollR.page.hide();
				Value.hideScreen[1][1] = 1;
				Value.hideScreen[1][2] = 1;
				Value.hideScreen[1][3] = 1;
			}
		} else {
			armR.page.hide();
			pitchR.page.hide();
			rollR.page.hide();
			thrR.page.hide();
			Value.hideScreen[1][0] = 1;
			Value.hideScreen[1][1] = 1;
			Value.hideScreen[1][2] = 1;
			Value.hideScreen[1][3] = 1;
		}
	},
	updateCommon: func(s, w) { # s is side, 1 is left, 2 is right, w is window, 0 thrust, 1 arm, 2 roll, 3 pitch
		if (w == 3 and fgs.Output.vert.getValue() == 1 and abs(fgs.Input.vs.getValue()) < 50) {
			Value.line1[w] = "ALT";
			Value.line2[w] = "HOLD";
		} else {
			Value.line1[w] = Modes.Line1[w].getValue();
			Value.line2[w] = Modes.Line2[w].getValue();
		}
		
		if (Value.line1[w] != Value.line1Old[s][w] or Value.line2[w] != Value.line2Old[s][w]) {
			Value.line1Old[s][w] = Value.line1[w];
			Value.line2Old[s][w] = Value.line2[w];
			Value.hideScreen[s][w] = 1;
		}
		
		if (Value.line2[w] == "") {
			me["Line1"].setTranslation(0, 28);
		} else {
			me["Line1"].setTranslation(0, 0);
		}
		
		if (Value.hideScreen[s][w]) {
			me["Line1"].setText("");
		} else {
			me["Line1"].setText(Value.line1[w]);
		}
		
		if (Value.line1[w] == "") {
			me["Line2"].setTranslation(0, -28);
		} else {
			me["Line2"].setTranslation(0, 0);
		}
		
		if (Value.hideScreen[s][w]) {
			me["Line2"].setText("");
		} else {
			me["Line2"].setText(Value.line2[w]);
		}
		
		# Last, resets screen to be visible next fresh
		if (Value.hideScreen[s][w]) {
			Value.hideScreen[s][w] = 0;
		}
	},
};

var canvasArmL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasArmL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(0, 1);
		
		if (Value.line1[1] == "DUAL" or Value.line1[1] == "E") {
			me["Line1"].setColor(0, 1, 0);
			me["Line2"].setColor(0, 1, 0);
		} else {
			me["Line1"].setColor(0.7333, 0.3803, 0);
			me["Line2"].setColor(0.7333, 0.3803, 0);
		}
	},
};

var canvasArmR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasArmR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(1, 1);
		
		if (Value.line1[1] == "DUAL" or Value.line1[1] == "E") {
			me["Line1"].setColor(0, 1, 0);
			me["Line2"].setColor(0, 1, 0);
		} else {
			me["Line1"].setColor(0.7333, 0.3803, 0);
			me["Line2"].setColor(0.7333, 0.3803, 0);
		}
	},
};

var canvasPitchL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPitchL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(0, 3);
	},
};

var canvasPitchR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPitchR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(1, 3);
	},
};

var canvasRollL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasRollL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(0, 2);
	},
};

var canvasRollR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasRollR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(1, 2);
	},
};

var canvasThrL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasThrL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(0, 0);
	},
};

var canvasThrR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasThrR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(1, 0);
	},
};

var setup = func() {
	armLDisplay = canvas.new({
		"name": "armL",
		"size": [160, 128],
		"view": [160, 128],
		"mipmapping": 1
	});
	armRDisplay = canvas.new({
		"name": "armR",
		"size": [160, 128],
		"view": [160, 128],
		"mipmapping": 1
	});
	pitchLDisplay = canvas.new({
		"name": "pitchL",
		"size": [160, 128],
		"view": [160, 128],
		"mipmapping": 1
	});
	pitchRDisplay = canvas.new({
		"name": "pitchR",
		"size": [160, 128],
		"view": [160, 128],
		"mipmapping": 1
	});
	rollLDisplay = canvas.new({
		"name": "rollL",
		"size": [160, 128],
		"view": [160, 128],
		"mipmapping": 1
	});
	rollRDisplay = canvas.new({
		"name": "rollR",
		"size": [160, 128],
		"view": [160, 128],
		"mipmapping": 1
	});
	thrLDisplay = canvas.new({
		"name": "thrL",
		"size": [160, 128],
		"view": [160, 128],
		"mipmapping": 1
	});
	thrRDisplay = canvas.new({
		"name": "thrR",
		"size": [160, 128],
		"view": [160, 128],
		"mipmapping": 1
	});
	
	armLDisplay.addPlacement({"node": "arm1.screen"});
	armRDisplay.addPlacement({"node": "arm2.screen"});
	pitchLDisplay.addPlacement({"node": "pitch1.screen"});
	pitchRDisplay.addPlacement({"node": "pitch2.screen"});
	rollLDisplay.addPlacement({"node": "roll1.screen"});
	rollRDisplay.addPlacement({"node": "roll2.screen"});
	thrLDisplay.addPlacement({"node": "thr1.screen"});
	thrRDisplay.addPlacement({"node": "thr2.screen"});
	
	var armLGroup = armLDisplay.createGroup();
	var armRGroup = armRDisplay.createGroup();
	var pitchLGroup = pitchLDisplay.createGroup();
	var pitchRGroup = pitchRDisplay.createGroup();
	var rollLGroup = rollLDisplay.createGroup();
	var rollRGroup = rollRDisplay.createGroup();
	var thrLGroup = thrLDisplay.createGroup();
	var thrRGroup = thrRDisplay.createGroup();
	
	armL = canvasArmL.new(armLGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	armR = canvasArmR.new(armRGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	pitchL = canvasPitchL.new(pitchLGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	pitchR = canvasPitchR.new(pitchRGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	rollL = canvasRollL.new(rollLGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	rollR = canvasRollR.new(rollRGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	thrL = canvasThrL.new(thrLGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	thrR = canvasThrR.new(thrRGroup, "Aircraft/DC-10/Nasal/Instruments/res/fma.svg");
	
	canvasBase.setup();
	update.start();
}

var update = maketimer(0.25, func() {
	canvasBase.update();
});
