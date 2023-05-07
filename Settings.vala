namespace Wds{

public class Settings : Gtk.Box{
	public Settings(){
		Object(orientation: Gtk.Orientation.VERTICAL, hexpand:true);
		this.init();
		this.append(text_gen);
		this.append(_box_general);

		// General Part
	
		_block_winmode = Block.append_blocks(_box_general, "Enabled window mode");
		_block_winmode.connect((boolean)=>{
			print(@"win $boolean\n");
			//TODO
		});
		_block_suspend = Block.append_blocks(_box_general, "Suspend the containr on inactivity");
		_block_suspend.connect((boolean)=>{
			print(@"suspend $boolean\n");
			//TODO
		});
		_block_invert = Block.append_blocks(_box_general, "Invert colors");
		_block_invert.connect((boolean)=>{
			print(@"invert $boolean\n");
			//TODO
		});
		
		// Window Part
		this.append(text_win);

	}
	private void init(){
		text_gen = new Gtk.Label("<big><b>General</b></big>"){halign=Gtk.Align.START, css_classes={"title"}, use_markup=true};
		text_win = new Gtk.Label("<big><b>Window</b></big>"){halign=Gtk.Align.START, css_classes={"title"}, use_markup=true};
		_box_general = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		_box_general.add_css_class("adwclamp");
	}
	private Gtk.Label		text_gen;
	private Gtk.Label		text_win;
	private Gtk.Box			_box_general;
	private Block 			_block_winmode;
	private Block 			_block_suspend;
	private Block 			_block_invert;
}


class Block : Gtk.Box{
	public Block(string text){
		Object(orientation : Gtk.Orientation.HORIZONTAL, hexpand: true, margin_top:5, margin_bottom:5, margin_start:5, margin_end:5);
		_label = new Gtk.Label(text);
		_switch = new Gtk.Switch(){
			halign = Gtk.Align.END, hexpand=true
		};
		base.append(_label);
		base.append(_switch);
		this.event();
	}
	private void event(){
		_switch.state_set.connect((stats) => {
				if (_func != null)
					_func(stats);
				return false;
		});
	}
	public static Block append_blocks(Gtk.Box box, string text){
		var tmp = new Block(text);
		// box.append(new Gtk.Separator(Gtk.Orientation.VERTICAL));
		box.append(tmp);
		// box.append(new Gtk.Separator(Gtk.Orientation.VERTICAL));
		return (owned)tmp;
	}
	public new void connect(Handler f){
		_func = f;
	}

    public delegate void Handler (bool stat);
	private Handler	_func;
	private Gtk.Label	_label;
	private Gtk.Switch	_switch;
}



}
