namespace Wds{

// --------------------------- //
//		INFO SCRIPT STRUCT:
// --------------------------- //

public struct InfoScript{
	InfoScript(string title, string subtitle, string path){
		this.title = title;
		this.subtitle = subtitle;
		this.path = path;
	}
	string title;
	string subtitle;
	string path;
}

// --------------------------- //
//		Class Script:
// --------------------------- //

public class Script: Gtk.Box{
	public Script(){
		Object(orientation: Gtk.Orientation.VERTICAL);
		this.init();
		this.event();
		this.add_row();

		// Append group of row and terminal
		_scroll.set_child(_group);
		this.append(_scroll);
		this.append(_terminal);
	}
	private void init(){
		_scroll = new Gtk.ScrolledWindow(){
			hexpand = true,
			vexpand = true,
			min_content_height = 300,
			min_content_width = 400,
		};
		_group = new Adw.PreferencesGroup(){title="Script", margin_top=10, margin_bottom=10, margin_start=20, margin_end=20};
		_terminal = new Terminal();
	}

	protected void add_row(){
		foreach(var i in makelist()){
			var tmp = new RowScript(i);
			var tmp_b = new Gtk.Button.from_icon_name("utilities-terminal-symbolic"){has_frame=false, valign=Gtk.Align.CENTER};

			tmp_b.clicked.connect(()=>{onClick(i);});
			tmp.add_suffix(tmp_b);
			_group.add(tmp);
		}
	}

	protected void event(){
		onClick.connect((i)=>{
			_terminal.call(i);
		});
	}

	// HERE ADD all your script (name, subtitle, script_path)
	private InfoScript []makelist(){
		InfoScript []list = {};
		list += InfoScript("shell.sh","Android Shell", "shell.sh");
		list += InfoScript("remove_video","", "quackdoc_scripts/remove-video.sh");
		list += InfoScript("waydroid gpu","", "quackdoc_scripts/waydroid-choose-gpu.sh");
		list += InfoScript("firewall", "", "quackdoc_scripts/way-firewalld.sh");
		list += InfoScript("waydroid 10 -> 11", "", "waydroid-10-11-switch-script/waydroid_10_11_switch.sh");
		list += InfoScript("add FOSS app", "", "wd-scripts/add-foss-apps.sh");
		list += InfoScript("add SmartDock", "", "wd-scripts/add-smart-dock.sh");
		list += InfoScript("Connect android studio", "", "wd-scripts/connect_android_studio.sh");
		list += InfoScript("navbar controll", "", "wd-scripts/navbar-control.sh");
		list += InfoScript("toggle keyboard", "", "wd-scripts/toggle_keyboard.sh");

		return list;
	}

	private signal void onClick(InfoScript script);

	private Gtk.ScrolledWindow		_scroll;
	private Adw.PreferencesGroup	_group;
	private Terminal				_terminal;
}

// Row's script

public class RowScript : Adw.ActionRow{
	public RowScript(InfoScript info){
		this._script_name = info.path;
		this.title = info.title;
		this.subtitle = info.subtitle;
	}
	private string _script_name;
}





// --------------------------- //
//		PART TERMINAL:
// --------------------------- //

public class Terminal : Adw.PreferencesGroup{
	public Terminal(){
		Object(title:"Terminal", margin_top:10, margin_bottom:10, margin_start:10, margin_end:10);
		this.init();
		base.add(_frame);
	}
	private void init(){
		_terminal = new Vte.Terminal(){
			input_enabled=true, vexpand=true
		};
		_terminal.add_css_class("terminal");
		_frame.add_css_class("terminal");
		_frame = new Gtk.Frame(null);
		_frame.set_child(_terminal);
	}
	public void call(InfoScript info){
		string file = @"script/$(info.path)";
		int mode = (int)Posix.S_IRUSR | (int)Posix.S_IWUSR | (int)Posix.S_IXUSR;
		FileUtils.chmod(file, mode);
		spawn({file});
	}
	private void spawn(string []argv){
		try{
			_terminal.spawn_sync(
					Vte.PtyFlags.DEFAULT, 
					null, 
					argv, 
					null, 
					SpawnFlags.DO_NOT_REAP_CHILD, null, out pid, null);
		}catch(Error e){
			printerr("%s", e.message);
		}
	}
	private Gtk.Frame		_frame;
	private Vte.Terminal	_terminal;
	private GLib.Pid		pid;
}

}
