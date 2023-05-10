namespace Wds{

class Window : Adw.ApplicationWindow{
	public Window(Gtk.Application app){
		Object(application: app, hexpand: true, default_height:600, default_width:400);
		init();
		onEvent();
		// Pages
		_viewStack.add_titled_with_icon (_settings, "", "Settings", "emblem-system-symbolic");
		_viewStack.add_titled_with_icon (_script, "", "Script", "application-x-executable-symbolic");
		_viewStack.add_titled_with_icon (_info, "", "Info", "emblem-important-symbolic");

		//Header Bar Title (Select page)
		var toolsViewTitle = new Adw.ViewSwitcherTitle ();
		toolsViewTitle.set_stack (_viewStack);
		toolsViewTitle.notify.connect (() => {
			_viewSwitcherBar.set_reveal (toolsViewTitle.get_title_visible ());
		});
		_headerBar.set_title_widget (toolsViewTitle);
		_headerBar.set_centering_policy (Adw.CenteringPolicy.STRICT);
	}

	private void init(){
		_banner =			new Adw.Banner(""){button_label="start"};
		_viewStack = 		new Adw.ViewStack (){hexpand=true, vexpand=true};
		_viewSwitcherBar =	new Adw.ViewSwitcherBar (){stack = _viewStack};
		_scroll =			new Gtk.ScrolledWindow(){child=_viewStack};
		_box =				new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		_settings =			new Wds.Settings();
		_info=				new Wds.Info();
		_script =			new Wds.Script();
		_headerBar =		new Adw.HeaderBar ();

		this.set_content (_box);
		// HEADER BAR
		_box.append (_headerBar);
		_box.append(_banner);
		_box.append(_scroll);
		_box.append(_viewSwitcherBar);
	}

	private void refresh_waydroid_status(){
		var	status = FakeShell.waydroid_status();
		if (status.container == false){
			_banner.title = "Waydroid Container is not started";
			_banner.revealed = true;
		}
		if (status.session == false){
			_banner.title = "Waydroid Session is not started";
			_banner.revealed = true;
		}
		//TODO empecher de cliquer si waydroid nest pas start
	}

	private void onEvent(){
		_banner.button_clicked.connect(()=>{
			Posix.system("waydroid session start");
			_settings.refresh();
			// _viewStack.visible = true;
		});
	}

	private Wds.Info			_info;
	private Wds.Script			_script;
	private Wds.Settings		_settings;

	private Adw.Banner			_banner;
	private Gtk.Box				_box;
	private Gtk.ScrolledWindow	_scroll;
	private Adw.ViewSwitcherBar	_viewSwitcherBar;
	private Adw.ViewStack		_viewStack;
	private Adw.HeaderBar		_headerBar;
}

}
