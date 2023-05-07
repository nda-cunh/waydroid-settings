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
		_block_winmode = new Block("Enabled Window mode");
		_block_suspend = new Block("Suspend the container on inactivity");
		_block_invert = new Block("Invert colors");

		base.add(_block_winmode);
		base.add(_block_suspend);
		base.add(_block_invert);
	}
	private Block _block_winmode;
	private Block _block_suspend;
	private Block _block_invert;
}

class Block : Adw.ActionRow{
	public Block(string text){
		Object(title:text);
		_switch = new Gtk.Switch(){valign=Gtk.Align.CENTER};
		base.add_suffix(_switch);
	}
	
	private Gtk.Switch	_switch;
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
}
