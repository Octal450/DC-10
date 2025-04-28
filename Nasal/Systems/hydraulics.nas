# McDonnell Douglas DC-10 Hydraulic System
# Copyright (c) 2025 Josh Davidson (Octal450)

var HYDRAULICS = {
	Psi: {
		auxPump1: props.globals.getNode("/systems/hydraulics/aux-pump-1-psi"),
		auxPump2: props.globals.getNode("/systems/hydraulics/aux-pump-2-psi"),
		lPump1: props.globals.getNode("/systems/hydraulics/l-eng-1-pump-psi"),
		lPump2: props.globals.getNode("/systems/hydraulics/l-eng-2-pump-psi"),
		lPump3: props.globals.getNode("/systems/hydraulics/l-eng-3-pump-psi"),
		rPump1: props.globals.getNode("/systems/hydraulics/r-eng-1-pump-psi"),
		rPump2: props.globals.getNode("/systems/hydraulics/r-eng-2-pump-psi"),
		rPump3: props.globals.getNode("/systems/hydraulics/r-eng-3-pump-psi"),
		sys1: props.globals.getNode("/systems/hydraulics/sys-1-psi"),
		sys2: props.globals.getNode("/systems/hydraulics/sys-2-psi"),
		sys3: props.globals.getNode("/systems/hydraulics/sys-3-psi"),
		sys3Aft: props.globals.getNode("/systems/hydraulics/sys-3-aft-psi"),
	},
	Qty: {
		sys1: props.globals.getNode("/systems/hydraulics/sys-1-qty"),
		sys1Input: props.globals.getNode("/systems/hydraulics/sys-1-qty-input"),
		sys2: props.globals.getNode("/systems/hydraulics/sys-2-qty"),
		sys2Input: props.globals.getNode("/systems/hydraulics/sys-2-qty-input"),
		sys3: props.globals.getNode("/systems/hydraulics/sys-3-qty"),
		sys3Input: props.globals.getNode("/systems/hydraulics/sys-3-qty-input"),
		sys3Aft: props.globals.getNode("/systems/hydraulics/sys-3-aft-qty"),
	},
	Controls: {
		auxPump1: props.globals.getNode("/controls/hydraulics/aux-pump-1"),
		auxPump2: props.globals.getNode("/controls/hydraulics/aux-pump-2"),
		gearGravityExt: props.globals.getNode("/controls/hydraulics/gear-gravity-ext"),
		lPump1: props.globals.getNode("/controls/hydraulics/l-pump-1"),
		lPump2: props.globals.getNode("/controls/hydraulics/l-pump-2"),
		lPump3: props.globals.getNode("/controls/hydraulics/l-pump-3"),
		pressTest: props.globals.getNode("/controls/hydraulics/press-test"),
		rPump1: props.globals.getNode("/controls/hydraulics/r-pump-1"),
		rPump2: props.globals.getNode("/controls/hydraulics/r-pump-2"),
		rPump3: props.globals.getNode("/controls/hydraulics/r-pump-3"),
		rmp13: props.globals.getNode("/controls/hydraulics/rmp-1-3"),
		rmp23: props.globals.getNode("/controls/hydraulics/rmp-2-3"),
	},
	Failures: {
		auxPump1: props.globals.getNode("/systems/failures/hydraulics/aux-pump-1"),
		auxPump2: props.globals.getNode("/systems/failures/hydraulics/aux-pump-2"),
		catastrophicAft: props.globals.getNode("/systems/failures/hydraulics/catastrophic-aft"),
		lPump1: props.globals.getNode("/systems/failures/hydraulics/l-pump-1"),
		lPump2: props.globals.getNode("/systems/failures/hydraulics/l-pump-2"),
		lPump3: props.globals.getNode("/systems/failures/hydraulics/l-pump-3"),
		nrmp21: props.globals.getNode("/systems/failures/hydraulics/nrmp-2-1"),
		nrmp32: props.globals.getNode("/systems/failures/hydraulics/nrmp-3-2"),
		rPump1: props.globals.getNode("/systems/failures/hydraulics/r-pump-1"),
		rPump2: props.globals.getNode("/systems/failures/hydraulics/r-pump-2"),
		rPump3: props.globals.getNode("/systems/failures/hydraulics/r-pump-3"),
		rmp13: props.globals.getNode("/systems/failures/hydraulics/rmp-1-3"),
		rmp23: props.globals.getNode("/systems/failures/hydraulics/rmp-2-3"),
		sys1Leak: props.globals.getNode("/systems/failures/hydraulics/sys-1-leak"),
		sys2Leak: props.globals.getNode("/systems/failures/hydraulics/sys-2-leak"),
		sys3Leak: props.globals.getNode("/systems/failures/hydraulics/sys-3-leak"),
	},
	init: func() {
		me.resetFailures();
		me.Qty.sys1Input.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Qty.sys2Input.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Qty.sys3Input.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Controls.auxPump1.setBoolValue(0);
		me.Controls.auxPump2.setBoolValue(0);
		me.Controls.gearGravityExt.setBoolValue(0);
		me.Controls.lPump1.setBoolValue(0);
		me.Controls.lPump2.setBoolValue(0);
		me.Controls.lPump3.setBoolValue(0);
		me.Controls.pressTest.setBoolValue(0);
		me.Controls.rPump1.setValue(0);
		me.Controls.rPump2.setValue(0);
		me.Controls.rPump3.setValue(0);
		me.Controls.rmp13.setBoolValue(0);
		me.Controls.rmp23.setBoolValue(0);
	},
	resetFailures: func() {
		me.Failures.auxPump1.setBoolValue(0);
		me.Failures.auxPump2.setBoolValue(0);
		me.Failures.catastrophicAft.setBoolValue(0);
		me.Failures.lPump1.setBoolValue(0);
		me.Failures.lPump2.setBoolValue(0);
		me.Failures.lPump3.setBoolValue(0);
		me.Failures.nrmp21.setBoolValue(0);
		me.Failures.nrmp32.setBoolValue(0);
		me.Failures.rPump1.setBoolValue(0);
		me.Failures.rPump2.setBoolValue(0);
		me.Failures.rPump3.setBoolValue(0);
		me.Failures.rmp13.setBoolValue(0);
		me.Failures.rmp23.setBoolValue(0);
		me.Failures.sys1Leak.setBoolValue(0);
		me.Failures.sys2Leak.setBoolValue(0);
		me.Failures.sys3Leak.setBoolValue(0);
	},
};
