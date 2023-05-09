namespace Wds{

public class Settings : Gtk.Box{
	public Settings(){
		Object(orientation: Gtk.Orientation.VERTICAL);
		this.init();
		this.append(_general);
		this.append(_window);
	}
	public void refresh(){
		_general.refresh();
		_window.refresh();
	}
	private void init(){
		_window = new WindowBlock();
		_general = new GeneralBlock();
	}
	private GeneralBlock	_general; 
	private WindowBlock		_window;
}

// --------------------------- //
//		PART GENERAL :
// --------------------------- //

class GeneralBlock : Adw.PreferencesGroup{
	public GeneralBlock(){
		Object(title:"General", margin_top:10, margin_bottom:10, margin_start:20, margin_end:20);
		
		_block_winmode = new Block("multi_windows"){
			title="Multi mode window integration",
			subtitle="only work on mutter (gnome)"
		};
		_block_suspend = new Block("suspend"){
			title="Suspend the container on inactivity",
			subtitle="Let the Waydroid container sleep when no apps are active"
		};
		_block_invert = new Block("invert_colors"){
			title="invert color",
			subtitle="Swaps the color space from RGBA to BGRA"
		};
		_block_uevent = new Block("uevent"){
			title="waydroid devices",
			subtitle="Allow android direct access to hotplugged devices"
		};

		base.add(_block_winmode);
		base.add(_block_suspend);
		base.add(_block_uevent);
		base.add(_block_invert);
		refresh();
	}
	public void refresh(){
		_block_winmode.refresh();
		_block_uevent.refresh(); 	
		_block_suspend.refresh();
		_block_invert.refresh();
	}
	private Block _block_winmode;
	private Block _block_uevent;
	private Block _block_suspend;
	private Block _block_invert;
}

class Block : Adw.ActionRow{
	public Block(string waydroid_mode){
		_property = waydroid_mode;
		_switch = new Gtk.Switch(){valign=Gtk.Align.CENTER};
		base.add_suffix(_switch);
		onEvent();
	}
	public void refresh(){
		bool activable = bool.parse(FakeShell.waydroid_get(_property));
		_switch.active = activable;
		_switch.state = activable;
	}
	private void onEvent(){
		_switch.state_set.connect((b)=> {
			FakeShell.waydroid_set(_property, b.to_string());
			onClick(b);
			return false;
		});
	}

	public bool state{get{ return _switch.state;}}
	public signal void onClick(bool boolean);
	private string		_property;
	private Gtk.Switch	_switch;
}

// --------------------------- //
//		PART WINDOW :
// --------------------------- //

class WindowBlock : Adw.PreferencesGroup{
	public WindowBlock(){
		Object(title:"Window", margin_top:10, margin_bottom:10, margin_start:20, margin_end:20);
		_timer = new Timer();
		_width = new Gtk.SpinButton.with_range(10, 4000, 10){valign=Gtk.Align.CENTER};
		_height = new Gtk.SpinButton.with_range(10, 4000, 10){valign=Gtk.Align.CENTER};
		_widthpadd = new Gtk.SpinButton.with_range(0, 4000, 10){valign=Gtk.Align.CENTER};
		_heightpadd = new Gtk.SpinButton.with_range(0, 4000, 10){valign=Gtk.Align.CENTER};
		_continue = true;
		
		var row1 = new Adw.ActionRow(){title="Width"};
		row1.add_suffix(_width);
		var row2 = new Adw.ActionRow(){title="Height"};
		row2.add_suffix(_height);
		var row3 = new Adw.ActionRow(){title="Height", subtitle="(padding)"};
		row3.add_suffix(_widthpadd);
		var row4 = new Adw.ActionRow(){title="Width", subtitle="(padding)"};
		row4.add_suffix(_heightpadd);
		
		base.add(row1);
		base.add(row2);
		base.add(row3);
		base.add(row4);
		refresh();
		onEvent();
	}
	public void refresh(){
		_width.value = double.parse(FakeShell.waydroid_get("width"));
		_height.value = double.parse(FakeShell.waydroid_get("height"));
		_widthpadd.value = double.parse(FakeShell.waydroid_get("width_padding"));
		_heightpadd.value = double.parse(FakeShell.waydroid_get("height_padding"));
	}
	private void onEvent(){

		_width.value_changed.connect(chrono);
		_height.value_changed.connect(chrono);		
		_heightpadd.value_changed.connect(chrono);		
		_widthpadd.value_changed.connect(chrono);
	}
	private void chrono(){
		_timer.reset(); _timer.start();
		if (_continue)
		{
			_continue = false;
			new Thread<void>("chrono", ()=>{
					while (_timer.elapsed() < 1.0)
						;
					FakeShell.waydroid_set("width", _width.value.to_string());
					FakeShell.waydroid_set("height", _height.value.to_string());
					FakeShell.waydroid_set("width_padding", _widthpadd.value.to_string());
					FakeShell.waydroid_set("height_padding", _heightpadd.value.to_string());
					_continue = true;
			});
		}
	}

	private bool			_continue;
	private Timer			_timer;
	private Gtk.SpinButton _width;
	private Gtk.SpinButton _height;
	private Gtk.SpinButton _widthpadd;
	private Gtk.SpinButton _heightpadd;
}
}
