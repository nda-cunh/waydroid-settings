namespace Wds{

public class Settings : Gtk.Box{
	public Settings(){
		Object(orientation: Gtk.Orientation.VERTICAL);
		this.init();
		this.append(_general_block);
		this.append(_window_block);
	}
	private void init(){
		_window_block = new WindowBlock();
		_general_block = new GeneralBlock();
	}
	private GeneralBlock	_general_block; 
	private WindowBlock		_window_block;
}

// --------------------------- //
//		PART GENERAL :
// --------------------------- //

class GeneralBlock : Adw.PreferencesGroup{
	public GeneralBlock(){
		Object(title:"General", margin_top:10, margin_bottom:10, margin_start:10, margin_end:10);
		
		_block_winmode = new Block("multi_windows"){
			title="Multi mode window integration",
			subtitle="only work on mutter (gnome)"
		};
		// _block_cursor= new Block("cursor_on_subsurface"){
			// title="Workaround for showing the cursor",
			// subtitle=""
		// };
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

		// onEvent();
		base.add(_block_winmode);
		// base.add(_block_cursor);
		base.add(_block_suspend);
		base.add(_block_uevent);
		base.add(_block_invert);
	}
	// private void onEvent(){
		// _block_cursor.visible = _block_winmode.state;
		// _block_winmode.onClick.connect((b)=>{
			// _block_cursor.visible = b;
		// });
	// }
	private Block _block_winmode;
	private Block _block_uevent;
	private Block _block_cursor;
	private Block _block_suspend;
	private Block _block_invert;
}

class Block : Adw.ActionRow{
	public Block(string waydroid_mode){
		_property = waydroid_mode;
		_switch = new Gtk.Switch(){valign=Gtk.Align.CENTER};
		base.add_suffix(_switch);
		bool activable = bool.parse(FakeShell.waydroid_get(waydroid_mode));
		print(@"$activable   here\n\n\n");
		_switch.active = activable;
		_switch.state = activable;
		this.event();
	}
	private void event(){
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
		Object(title:"Window", margin_top:10, margin_bottom:10, margin_start:10, margin_end:10);
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
		onEvent();
	}
	private void onEvent(){
		_width.value = double.parse(FakeShell.waydroid_get("width"));
		_height.value = double.parse(FakeShell.waydroid_get("height"));
		_widthpadd.value = double.parse(FakeShell.waydroid_get("width_padding"));
		_heightpadd.value = double.parse(FakeShell.waydroid_get("height_padding"));

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
