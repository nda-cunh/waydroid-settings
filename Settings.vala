namespace Wds{

public class Settings : Gtk.Box{
	public Settings(){
		Object(orientation: Gtk.Orientation.VERTICAL, hexpand:true);
		
		var text_gen = new Gtk.Label("<big><b>General</b></big>"){halign=Gtk.Align.START, use_markup=true, margin_bottom=5, margin_start=5, margin_top=5};
		var text_win = new Gtk.Label("<big><b>Window</b></big>"){halign=Gtk.Align.START, use_markup=true, margin_bottom=5, margin_start=5, margin_top=5};

		// General Part
		this.append(text_gen);
		this.append(new Gtk.Separator(Gtk.Orientation.VERTICAL));
		
		_block_winmode = Block.append_blocks(this, "Enabled window mode");
		_block_winmode.connect((boolean)=>{
			print(@"win $boolean\n");
			//TODO
		});
		_block_suspend = Block.append_blocks(this, "Suspend the containr on inactivity");
		_block_suspend.connect((boolean)=>{
			print(@"suspend $boolean\n");
			//TODO
		});
		_block_invert = Block.append_blocks(this, "Invert colors");
		_block_invert.connect((boolean)=>{
			print(@"invert $boolean\n");
			//TODO
		});
		this.append(new Gtk.Separator(Gtk.Orientation.VERTICAL));
		
		// Window Part
		this.append(text_win);
		this.append(new Gtk.Separator(Gtk.Orientation.VERTICAL));
	}
	private Block _block_winmode;
	private Block _block_suspend;
	private Block _block_invert;
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
		box.append(new Gtk.Separator(Gtk.Orientation.VERTICAL));
		box.append(tmp);
		box.append(new Gtk.Separator(Gtk.Orientation.VERTICAL));
		return (owned)tmp;
	}
	public void connect(Handler f){
		_func = f;
	}

    public delegate void Handler (bool stat);
	private Handler	_func;
	private Gtk.Label	_label;
	private Gtk.Switch	_switch;
}



}
