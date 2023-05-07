namespace Wds{

public class Settings : Gtk.Box{
	public Settings(){
		Object(orientation: Gtk.Orientation.VERTICAL);
		this.init();
		this.append(_group);

		// General Part
		_block_winmode = Block.append_blocks(_group, "Enabled window mode");
		_block_suspend = Block.append_blocks(_group, "Suspend the containr on inactivity");
		_block_invert = Block.append_blocks(_group, "Invert colors");
		
		// Window Part
		this.append(_window_block);
	}
	private void init(){
		_group = new Adw.PreferencesGroup(){title="General", margin_top=10, margin_bottom=10, margin_start=10, margin_end=10};
		_window_block = new WindowBlock();
	}
	private Adw.PreferencesGroup	_group;
	private Block 					_block_winmode;
	private Block 					_block_suspend;
	private Block 					_block_invert;
	private WindowBlock 			_window_block;
}

// --------------------------- //
//		PART GENERAL :
// --------------------------- //

class Block : Adw.ActionRow{
	public Block(string text){
		Object(title:text);
		_switch = new Gtk.Switch(){valign=Gtk.Align.CENTER};
		base.add_suffix(_switch);
		this.event();
	}
	private void event(){
		_switch.state_set.connect((stats) => {
				if (_func != null)
					_func(stats);
				return false;
		});
	}
	public static Block append_blocks(Adw.PreferencesGroup box, string text){
		var tmp = new Block(text);
		box.add(tmp);
		return (owned)tmp;
	}
	public new void connect(Handler f){
		_func = f;
	}

    public delegate void Handler (bool stat);
	private Handler	_func;
	private Gtk.Switch	_switch;
}
}

// --------------------------- //
//		PART WINDOW :
// --------------------------- //

class WindowBlock : Adw.PreferencesGroup{
	public WindowBlock(){
		Object(title:"Window", margin_top:10, margin_bottom:10, margin_start:10, margin_end:10);
		_width = new Gtk.SpinButton.with_range(10, 4000, 10){valign=Gtk.Align.CENTER};
		_height = new Gtk.SpinButton.with_range(10, 4000, 10){valign=Gtk.Align.CENTER};
		_widthpadd = new Gtk.SpinButton.with_range(10, 4000, 10){valign=Gtk.Align.CENTER};
		_heightpadd = new Gtk.SpinButton.with_range(10, 4000, 10){valign=Gtk.Align.CENTER};
		
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
	}

	private Gtk.SpinButton _width;
	private Gtk.SpinButton _height;
	private Gtk.SpinButton _widthpadd;
	private Gtk.SpinButton _heightpadd;
}
