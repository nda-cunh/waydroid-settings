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

namespace Wds{

public class Script: Gtk.Box{
	public Script(){
		Object(orientation: Gtk.Orientation.VERTICAL);
		this.init();
		this.event();
		this.add_row();

		// Append group of row and terminal
		this.append(_group);
		this.append(_terminal);
	}
	private void init(){
		_group = new Adw.PreferencesGroup(){title="Script", margin_top=10, margin_bottom=10, margin_start=10, margin_end=10};
		_terminal = new Terminal();
	}

	protected void add_row(){
		foreach(var i in makelist()){
			var tmp = new RowScript(i.path){title=i.title, subtitle=i.subtitle};
			var tmp_b = new Gtk.Button.from_icon_name("terminal-symbolic"){has_frame=false, valign=Gtk.Align.CENTER};

			tmp_b.clicked.connect(()=>{onClick(i);});
			tmp.add_suffix(tmp_b);
			_group.add(tmp);
		}
	}

	protected void event(){
		onClick.connect((i)=>{
			print("%s is clicked\n", i.title);
			_terminal.call(i);
		});
	}

	private InfoScript []makelist(){
		InfoScript []list = {};
		list += InfoScript("coucou.sh", "", "/nfs/homes/nda-cunh/Desktop/waydroid-settings/script/coucou.sh");
		list += InfoScript("hello.sh", "", "script/hello.sh");
		list += InfoScript("Teste abc", "abc Teste", "/bin/bash");

		return list;
	}

	private signal void onClick(InfoScript script);

	private Adw.PreferencesGroup	_group;
	private Terminal				_terminal;
}

public class RowScript : Adw.ActionRow{
	public RowScript(string script_name){
		_script_name = script_name;
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
		spawn({"bash"});
	}
	public void call(InfoScript info){
		print("%s", info.title);
		spawn({info.path});
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
