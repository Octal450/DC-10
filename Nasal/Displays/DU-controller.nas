# McDonnell Douglas DC-10 DU Controller
# Copyright (c) 2026 Josh Davidson (Octal450)
# This controls the DU's in an efficient and synchronized way

var DUController = {
	eidsOn: props.globals.initNode("/instrumentation/eids/lcd-on", 0, "BOOL"),
	eng: pts.Options.eng.getValue(),
	PowerSource: {
		lEmerAc: 0,
	},
	updateEids: 0,
	loop: func() {
		me.PowerSource.lEmerAc = systems.ELECTRICAL.Bus.lEmerAc.getValue();
		
		# L Emer AC
		if (me.PowerSource.lEmerAc >= 112 and pts.Systems.Acconfig.Options.eids.getBoolValue()) {
			if (!me.updateEids) {
				me.updateEids = 1;
				if (me.eng == "PW") {
					canvas_eids.ge.page.hide();
					canvas_eids.pw.update();
					me.eidsOn.setBoolValue(1);
					canvas_eids.pw.page.show();
				} else {
					canvas_eids.pw.page.hide();
					canvas_eids.ge.update();
					me.eidsOn.setBoolValue(1);
					canvas_eids.ge.page.show();
				}
			}
		} else {
			if (me.updateEids) {
				me.updateEids = 0;
				canvas_eids.ge.page.hide();
				canvas_eids.pw.page.hide();
				me.eidsOn.setBoolValue(0);
			}
		}
	},
};
