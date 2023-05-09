namespace Wds{

class Window : Adw.ApplicationWindow{
	public Window(Gtk.Application app){
		Object(application: app, hexpand: true, default_height:600, default_width:400);
		init();

		// Pages
		_viewStack.add_titled_with_icon (new Wds.Settings (), "", "Settings", "emblem-system-symbolic");
		_viewStack.add_titled_with_icon (new Wds.Script(), "", "Script", "application-x-executable-symbolic");
		_viewStack.add_titled_with_icon (new Gtk.Label("TODO"), "", "Tools", "emblem-important-symbolic");
		
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
		_banner =			new Adw.Banner("Waydroid is not starting"){button_label="start"};
		_scroll =			new Gtk.ScrolledWindow();
		_headerBar =		new Adw.HeaderBar ();
		_box =				new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		_viewStack = 		new Adw.ViewStack (){hexpand=true, vexpand=true};
		_viewSwitcherBar =	new Adw.ViewSwitcherBar (){stack = _viewStack};
		
		this.set_content (_box);
		// HEADER BAR
		_box.append (_headerBar);
		_box.append(_banner);
		
		//TODO add revealed only is waydroid is not starded (call fakeshell)
		_banner.revealed=true;
		//TODO call .refresh at Wds.settings Wds.Script (create refresh function)
	

		_box.append(_scroll);
		_scroll.set_child(_viewStack);
		_box.append(_viewSwitcherBar);
	}

	private Adw.Banner			_banner;
	private Gtk.Box				_box;
	private Gtk.ScrolledWindow	_scroll;
	private Adw.ViewSwitcherBar	_viewSwitcherBar;
	private Adw.ViewStack		_viewStack;
	private Adw.HeaderBar		_headerBar;
}

}
