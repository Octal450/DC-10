# McDonnell Douglas DC-10 AvVance EIDS
# Copyright (c) 2026 Josh Davidson (Octal450)

var display = nil;
var ge = nil;
var pw = nil;

var Value = {
	egt: [0, 0, 0],
	epr: [0, 0, 0],
	eprLim: 0,
	eprRound: [0, 0, 0],
	ff: [0, 0, 0],
	engType: "GE",
	n1: [0, 0, 0],
	n1Lim: 0,
	n1Round: [0, 0, 0],
	n2: [0, 0, 0],
};

var CanvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "AvVanceDU.ttf";
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
			
			var clip_el = canvasGroup.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tranRect = clip_el.getTransformedBounds();
				
				var clip_rect = sprintf("rect(%d, %d, %d, %d)",
					tranRect[1], # 0 ys
					tranRect[2], # 1 xe
					tranRect[3], # 2 ye
					tranRect[0] # 3 xs
				);
				
				# Coordinates are top, right, bottom, left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.page = canvasGroup;
		return me;
	},
	setup: func() {
		# Hide the pages by default
		ge.page.hide();
		ge.setup();
		pw.page.hide();
		pw.setup();
		
		Value.engType = pts.Options.eng.getValue();
	},
	update: func() {
		if (systems.DUController.updateEids) {
			if (systems.DUController.eng == "PW") {
				pw.update();
			} else {
				ge.update();
			}
		}
	},
};

var CanvasGe = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasGe, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return KeyListGe;
	},
	setup: func() {
	},
	update: func() {
		# N1 Limit
		if (pts.Instrumentation.Eids.limitMode.getValue() == 0) {
			me["N1Lim_mode"].setText("AUTO");
			Value.N1Lim = systems.THRLIM.Limit.active.getValue();
		} else {
			me["N1Lim_mode"].setText("MAN");
			Value.N1Lim = pts.Instrumentation.Eids.manN1.getValue();
		}
		
		me["N11_lim"].setTranslation(0, math.clamp(Value.N1Lim / 125 * -450, -450, 0));
		me["N12_lim"].setTranslation(0, math.clamp(Value.N1Lim / 125 * -450, -450, 0));
		me["N13_lim"].setTranslation(0, math.clamp(Value.N1Lim / 125 * -450, -450, 0));
		me["N1Lim"].setText(sprintf("%5.1f", Value.N1Lim));
		
		# N1
		Value.n1[0] = systems.ENGINES.n1[0].getValue();
		Value.n1[1] = systems.ENGINES.n1[1].getValue();
		Value.n1[2] = systems.ENGINES.n1[2].getValue();
		
		Value.n1Round[0] = math.round(Value.n1[0], 0.01);
		Value.n1Round[1] = math.round(Value.n1[1], 0.01);
		Value.n1Round[2] = math.round(Value.n1[2], 0.01);
		
		if (Value.n1Round[0] < 99) { # Prepare to show the zero at 100
			me["N11_tens_zero"].hide();
		} else {
			me["N11_tens_zero"].show();
		}
		if (Value.n1Round[0] < 9) { # Prepare to show the zero at 10
			me["N11_ones_zero"].hide();
		} else {
			me["N11_ones_zero"].show();
		}
		
		me["N11_hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%06.2f", Value.n1Round[0]), 6))) * 50);
		me["N11_tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%05.2f", Value.n1Round[0]), 5))) * 50);
		me["N11_ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%04.2f", Value.n1Round[0]), 4))) * 50);
		me["N11_tenths"].setTranslation(0, (10 * math.mod(Value.n1Round[0], 1) * 50));
		
		if (Value.n1Round[1] < 99) { # Prepare to show the zero at 100
			me["N12_tens_zero"].hide();
		} else {
			me["N12_tens_zero"].show();
		}
		if (Value.n1Round[1] < 9) { # Prepare to show the zero at 10
			me["N12_ones_zero"].hide();
		} else {
			me["N12_ones_zero"].show();
		}
		
		me["N12_hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%06.2f", Value.n1Round[1]), 6))) * 50);
		me["N12_tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%05.2f", Value.n1Round[1]), 5))) * 50);
		me["N12_ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%04.2f", Value.n1Round[1]), 4))) * 50);
		me["N12_tenths"].setTranslation(0, (10 * math.mod(Value.n1Round[1], 1) * 50));
		
		if (Value.n1Round[2] < 99) { # Prepare to show the zero at 100
			me["N13_tens_zero"].hide();
		} else {
			me["N13_tens_zero"].show();
		}
		if (Value.n1Round[2] < 9) { # Prepare to show the zero at 10
			me["N13_ones_zero"].hide();
		} else {
			me["N13_ones_zero"].show();
		}
		
		me["N13_hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%06.2f", Value.n1Round[2]), 6))) * 50);
		me["N13_tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%05.2f", Value.n1Round[2]), 5))) * 50);
		me["N13_ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%04.2f", Value.n1Round[2]), 4))) * 50);
		me["N13_tenths"].setTranslation(0, (10 * math.mod(Value.n1Round[2], 1) * 50));
		
		me["N11_bar"].setTranslation(0, math.clamp(Value.n1[0] / 125 * -450, -450, 0));
		me["N12_bar"].setTranslation(0, math.clamp(Value.n1[1] / 125 * -450, -450, 0));
		me["N13_bar"].setTranslation(0, math.clamp(Value.n1[2] / 125 * -450, -450, 0));
		
		# N2
		Value.n2[0] = systems.ENGINES.n2[0].getValue();
		Value.n2[1] = systems.ENGINES.n2[1].getValue();
		Value.n2[2] = systems.ENGINES.n2[2].getValue();
		
		me["N21_bar"].setTranslation(0, math.clamp(Value.n2[0] / 112.5 * -573.75, -573.75, 0));
		if (Value.n2[0] - 0.05 > 107.5) {
			me["N21_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N21_bar"].setColorFill(1, 1, 1);
		}
		
		me["N22_bar"].setTranslation(0, math.clamp(Value.n2[1] / 112.5 * -573.75, -573.75, 0));
		if (Value.n2[1] - 0.05 > 107.5) {
			me["N22_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N22_bar"].setColorFill(1, 1, 1);
		}
		
		me["N23_bar"].setTranslation(0, math.clamp(Value.n2[2] / 112.5 * -573.75, -573.75, 0));
		if (Value.n2[2] - 0.05 > 107.5) {
			me["N23_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N23_bar"].setColorFill(1, 1, 1);
		}
		
		# EGT
		Value.egt[0] = systems.ENGINES.egt[0].getValue();
		Value.egt[1] = systems.ENGINES.egt[1].getValue();
		Value.egt[2] = systems.ENGINES.egt[2].getValue();
		
		me["EGT1_bar"].setTranslation(0, -160 / 500 * math.clamp(Value.egt[0], 0, 500) - 152 / 200 * math.clamp(Value.egt[0] - 500, 0, 200) - 261.32 / 278 * math.clamp(Value.egt[0] - 700, 0, 278));
		if (Value.egt[0] - 0.5 > 960) {
			me["EGT1_bar"].setColorFill(1, 0, 0);
		} else if (Value.egt[0] - 0.5 > 910) {
			me["EGT1_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["EGT1_bar"].setColorFill(1, 1, 1);
		}
		
		me["EGT2_bar"].setTranslation(0, -160 / 500 * math.clamp(Value.egt[1], 0, 500) - 152 / 200 * math.clamp(Value.egt[1] - 500, 0, 200) - 261.32 / 278 * math.clamp(Value.egt[1] - 700, 0, 278));
		if (Value.egt[1] - 0.5 > 960) {
			me["EGT2_bar"].setColorFill(1, 0, 0);
		} else if (Value.egt[1] - 0.5 > 910) {
			me["EGT2_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["EGT2_bar"].setColorFill(1, 1, 1);
		}
		
		me["EGT3_bar"].setTranslation(0, -160 / 500 * math.clamp(Value.egt[2], 0, 500) - 152 / 200 * math.clamp(Value.egt[2] - 500, 0, 200) - 261.32 / 278 * math.clamp(Value.egt[2] - 700, 0, 278));
		if (Value.egt[2] - 0.5 > 960) {
			me["EGT3_bar"].setColorFill(1, 0, 0);
		} else if (Value.egt[2] - 0.5 > 910) {
			me["EGT3_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["EGT3_bar"].setColorFill(1, 1, 1);
		}
		
		# FF
		Value.ff[0] = systems.ENGINES.ff[0].getValue();
		Value.ff[1] = systems.ENGINES.ff[1].getValue();
		Value.ff[2] = systems.ENGINES.ff[2].getValue();
		
		me["FF_total"].setText(sprintf("%5.2f", math.round((Value.ff[0] + Value.ff[1] + Value.ff[2]) / 1000, 0.05)));
		me["FF1_bar"].setTranslation(0, -152 / 2000 * math.clamp(Value.ff[0], 0, 2000) - 52 / 3000 * math.clamp(Value.ff[0] - 2000, 0, 3000) - 270 / 15000 * math.clamp(Value.ff[0] - 5000, 0, 15000) - 38 / 10000 * math.clamp(Value.ff[0] - 20000, 0, 10000));
		me["FF2_bar"].setTranslation(0, -152 / 2000 * math.clamp(Value.ff[1], 0, 2000) - 52 / 3000 * math.clamp(Value.ff[1] - 2000, 0, 3000) - 270 / 15000 * math.clamp(Value.ff[1] - 5000, 0, 15000) - 38 / 10000 * math.clamp(Value.ff[1] - 20000, 0, 10000));
		me["FF3_bar"].setTranslation(0, -152 / 2000 * math.clamp(Value.ff[2], 0, 2000) - 52 / 3000 * math.clamp(Value.ff[2] - 2000, 0, 3000) - 270 / 15000 * math.clamp(Value.ff[2] - 5000, 0, 15000) - 38 / 10000 * math.clamp(Value.ff[2] - 20000, 0, 10000));
	},
};

var CanvasPw = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasPw, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return KeyListPw;
	},
	setup: func() {
	},
	update: func() {
		# EPR Limit
		if (pts.Instrumentation.Eids.limitMode.getValue() == 0) {
			me["EPRLim_mode"].setText("AUTO");
			Value.EprLim = systems.THRLIM.Limit.active.getValue();
		} else {
			me["EPRLim_mode"].setText("MAN");
			Value.EprLim = pts.Instrumentation.Eids.manEpr.getValue();
		}
		
		me["EPR1_lim"].setTranslation(0, math.clamp((Value.EprLim - 0.6) / 1.2 * -432, -432, 0));
		me["EPR2_lim"].setTranslation(0, math.clamp((Value.EprLim - 0.6) / 1.2 * -432, -432, 0));
		me["EPR3_lim"].setTranslation(0, math.clamp((Value.EprLim - 0.6) / 1.2 * -432, -432, 0));
		me["EPRLim"].setText(sprintf("%4.2f", Value.EprLim));
		
		# EPR
		Value.epr[0] = systems.ENGINES.epr[0].getValue();
		Value.epr[1] = systems.ENGINES.epr[1].getValue();
		Value.epr[2] = systems.ENGINES.epr[2].getValue();
		
		Value.eprRound[0] = math.round(Value.epr[0], 0.001);
		Value.eprRound[1] = math.round(Value.epr[1], 0.001);
		Value.eprRound[2] = math.round(Value.epr[2], 0.001);
		
		me["EPR1_ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%05.2f", Value.eprRound[0] * 10), 5))) * 50);
		me["EPR1_tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%04.2f", Value.eprRound[0] * 10), 4))) * 50);
		me["EPR1_hundreths"].setTranslation(0, 10 * (math.mod(Value.eprRound[0] * 10, 1) * 50));
		
		me["EPR2_ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%05.2f", Value.eprRound[1] * 10), 5))) * 50);
		me["EPR2_tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%04.2f", Value.eprRound[1] * 10), 4))) * 50);
		me["EPR2_hundreths"].setTranslation(0, 10 * (math.mod(Value.eprRound[1] * 10, 1) * 50));
		
		me["EPR3_ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%05.2f", Value.eprRound[2] * 10), 5))) * 50);
		me["EPR3_tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%04.2f", Value.eprRound[2] * 10), 4))) * 50);
		me["EPR3_hundreths"].setTranslation(0, 10 * (math.mod(Value.eprRound[2] * 10, 1) * 50));
		
		me["EPR1_bar"].setTranslation(0, math.clamp((Value.epr[0] - 0.6) / 1.2 * -432, -432, 0));
		me["EPR2_bar"].setTranslation(0, math.clamp((Value.epr[1] - 0.6) / 1.2 * -432, -432, 0));
		me["EPR3_bar"].setTranslation(0, math.clamp((Value.epr[2] - 0.6) / 1.2 * -432, -432, 0));
		
		# N1
		Value.n1[0] = systems.ENGINES.n1[0].getValue();
		Value.n1[1] = systems.ENGINES.n1[1].getValue();
		Value.n1[2] = systems.ENGINES.n1[2].getValue();
		
		me["N11_bar"].setTranslation(0, -94 / 10 * math.clamp(Value.n1[0], 0, 10) - 66 / 10 * math.clamp(Value.n1[0] - 10, 0, 10) - 120 / 30 * math.clamp(Value.n1[0] - 20, 0, 30) - 294 / 60 * math.clamp(Value.n1[0] - 50, 0, 60));
		if (Value.n1[0] - 0.05 > 103) {
			me["N11_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N11_bar"].setColorFill(1, 1, 1);
		}
		
		me["N12_bar"].setTranslation(0, -94 / 10 * math.clamp(Value.n1[1], 0, 10) - 66 / 10 * math.clamp(Value.n1[1] - 10, 0, 10) - 120 / 30 * math.clamp(Value.n1[1] - 20, 0, 30) - 294 / 60 * math.clamp(Value.n1[1] - 50, 0, 60));
		if (Value.n1[1] - 0.05 > 103) {
			me["N12_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N12_bar"].setColorFill(1, 1, 1);
		}
		
		me["N13_bar"].setTranslation(0, -94 / 10 * math.clamp(Value.n1[2], 0, 10) - 66 / 10 * math.clamp(Value.n1[2] - 10, 0, 10) - 120 / 30 * math.clamp(Value.n1[2] - 20, 0, 30) - 294 / 60 * math.clamp(Value.n1[2] - 50, 0, 60));
		if (Value.n1[2] - 0.05 > 103) {
			me["N13_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N13_bar"].setColorFill(1, 1, 1);
		}
		
		# N2
		Value.n2[0] = systems.ENGINES.n2[0].getValue();
		Value.n2[1] = systems.ENGINES.n2[1].getValue();
		Value.n2[2] = systems.ENGINES.n2[2].getValue();
		
		me["N21_bar"].setTranslation(0, -60 / 10 * math.clamp(Value.n2[0], 0, 10) - 192 / 30 * math.clamp(Value.n2[0] - 10, 0, 30) - 320.95 / 65.5 * math.clamp(Value.n2[0] - 40, 0, 65.5));
		if (Value.n2[0] - 0.05 > 97) {
			me["N21_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N21_bar"].setColorFill(1, 1, 1);
		}
		
		me["N22_bar"].setTranslation(0, -60 / 10 * math.clamp(Value.n2[1], 0, 10) - 192 / 30 * math.clamp(Value.n2[1] - 10, 0, 30) - 320.95 / 65.5 * math.clamp(Value.n2[1] - 40, 0, 65.5));
		if (Value.n2[1] - 0.05 > 97) {
			me["N22_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N22_bar"].setColorFill(1, 1, 1);
		}
		
		me["N23_bar"].setTranslation(0, -60 / 10 * math.clamp(Value.n2[2], 0, 10) - 192 / 30 * math.clamp(Value.n2[2] - 10, 0, 30) - 320.95 / 65.5 * math.clamp(Value.n2[2] - 40, 0, 65.5));
		if (Value.n2[2] - 0.05 > 97) {
			me["N23_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["N23_bar"].setColorFill(1, 1, 1);
		}
		
		# EGT
		Value.egt[0] = systems.ENGINES.egt[0].getValue();
		Value.egt[1] = systems.ENGINES.egt[1].getValue();
		Value.egt[2] = systems.ENGINES.egt[2].getValue();
		
		me["EGT1_bar"].setTranslation(0, math.clamp(Value.egt[0] / 700 * -574, -574, 0));
		if (Value.egt[0] - 0.5 > 685) {
			me["EGT1_bar"].setColorFill(1, 0, 0);
		} else if (Value.egt[0] - 0.5 > 650) {
			me["EGT1_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["EGT1_bar"].setColorFill(1, 1, 1);
		}
		
		me["EGT2_bar"].setTranslation(0, math.clamp(Value.egt[1] / 700 * -574, -574, 0));
		if (Value.egt[1] - 0.5 > 685) {
			me["EGT2_bar"].setColorFill(1, 0, 0);
		} else if (Value.egt[1] - 0.5 > 650) {
			me["EGT2_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["EGT2_bar"].setColorFill(1, 1, 1);
		}
		
		me["EGT3_bar"].setTranslation(0, math.clamp(Value.egt[2] / 700 * -574, -574, 0));
		if (Value.egt[2] - 0.5 > 685) {
			me["EGT3_bar"].setColorFill(1, 0, 0);
		} else if (Value.egt[2] - 0.5 > 650) {
			me["EGT3_bar"].setColorFill(1, 0.804, 0);
		} else {
			me["EGT3_bar"].setColorFill(1, 1, 1);
		}
		
		# FF
		Value.ff[0] = systems.ENGINES.ff[0].getValue();
		Value.ff[1] = systems.ENGINES.ff[1].getValue();
		Value.ff[2] = systems.ENGINES.ff[2].getValue();
		
		me["FF_total"].setText(sprintf("%5.2f", math.round((Value.ff[0] + Value.ff[1] + Value.ff[2]) / 1000, 0.05)));
		me["FF1_bar"].setTranslation(0, -152 / 2000 * math.clamp(Value.ff[0], 0, 2000) - 52 / 3000 * math.clamp(Value.ff[0] - 2000, 0, 3000) - 270 / 15000 * math.clamp(Value.ff[0] - 5000, 0, 15000) - 38 / 10000 * math.clamp(Value.ff[0] - 20000, 0, 10000));
		me["FF2_bar"].setTranslation(0, -152 / 2000 * math.clamp(Value.ff[1], 0, 2000) - 52 / 3000 * math.clamp(Value.ff[1] - 2000, 0, 3000) - 270 / 15000 * math.clamp(Value.ff[1] - 5000, 0, 15000) - 38 / 10000 * math.clamp(Value.ff[1] - 20000, 0, 10000));
		me["FF3_bar"].setTranslation(0, -152 / 2000 * math.clamp(Value.ff[2], 0, 2000) - 52 / 3000 * math.clamp(Value.ff[2] - 2000, 0, 3000) - 270 / 15000 * math.clamp(Value.ff[2] - 5000, 0, 15000) - 38 / 10000 * math.clamp(Value.ff[2] - 20000, 0, 10000));
	},
};

var setup = func() {
	display = canvas.new({
		"name": "EIDS",
		"size": [2048, 768],
		"view": [2048, 768],
		"mipmapping": 1
	});
	
	display.addPlacement({"node": "eids.screen"});
	
	var geGroup = display.createGroup();
	var pwGroup = display.createGroup();
	
	ge = CanvasGe.new(geGroup, "Aircraft/DC-10/Nasal/Displays/res/EIDS-GE.svg");
	pw = CanvasPw.new(pwGroup, "Aircraft/DC-10/Nasal/Displays/res/EIDS-PW.svg");
	
	CanvasBase.setup();
	update.start();
}

var update = maketimer(0.05, func() { # 20FPS
	CanvasBase.update();
});

var showEids = func() {
	var dlg = canvas.Window.new([1024, 384], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(display);
	dlg.set("title", "Engine Instrument Display System");
}

var m = 0;
var s = 0;

var genevaN1Hundreds = func(input) {
	m = math.floor(input / 100);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9 or math.mod(input / 100, 1) < 0.9) s = 0;
	return m + s;
}

var genevaN1Tens = func(input) {
	m = math.floor(input / 10);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaN1Ones = func(input) {
	m = math.floor(input);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	return m + s;
}

var genevaEprOnes = func(input) {
	m = math.floor(input / 10);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaEprTenths = func(input) {
	m = math.floor(input);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	return m + s;
}

# SVG Key Lists
var KeyListGe = [
	"EGT1_bar",
	"EGT2_bar",
	"EGT3_bar",
	"FF1_bar",
	"FF2_bar",
	"FF3_bar",
	"FF_total",
	"N11_bar",
	"N11_hundreds",
	"N11_lim",
	"N11_ones",
	"N11_ones_zero",
	"N11_tens",
	"N11_tens_zero",
	"N11_tenths",
	"N12_bar",
	"N12_hundreds",
	"N12_lim",
	"N12_ones",
	"N12_ones_zero",
	"N12_tens",
	"N12_tens_zero",
	"N12_tenths",
	"N13_bar",
	"N13_hundreds",
	"N13_lim",
	"N13_ones",
	"N13_ones_zero",
	"N13_tens",
	"N13_tens_zero",
	"N13_tenths",
	"N1Lim",
	"N1Lim_mode",
	"N21_bar",
	"N22_bar",
	"N23_bar"
];

var KeyListPw = [
	"EGT1_bar",
	"EGT2_bar",
	"EGT3_bar",
	"FF1_bar",
	"FF2_bar",
	"FF3_bar",
	"FF_total",
	"EPR1_bar",
	"EPR1_hundreths",
	"EPR1_lim",
	"EPR1_ones",
	"EPR1_tenths",
	"EPR2_bar",
	"EPR2_hundreths",
	"EPR2_lim",
	"EPR2_ones",
	"EPR2_tenths",
	"EPR3_bar",
	"EPR3_hundreths",
	"EPR3_lim",
	"EPR3_ones",
	"EPR3_tenths",
	"EPRLim",
	"EPRLim_mode",
	"N11_bar",
	"N12_bar",
	"N13_bar",
	"N21_bar",
	"N22_bar",
	"N23_bar"
];
