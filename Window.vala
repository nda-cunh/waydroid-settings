namespace Wds{

class Window : Adw.ApplicationWindow{
	public Window(Gtk.Application app){
		Object(application: app, hexpand: true, default_height:500, default_width:400);
		init();

		// Pages
		_viewStack.add_titled_with_icon (new Wds.Settings (), "", "Settings", "emblem-system-symbolic");
		_viewStack.add_titled_with_icon (new Wds.Script(), "", "Script", "emblem-system-symbolic");
		_viewStack.add_titled_with_icon (new Wds.Settings (), "", "Tools", "emblem-system-symbolic");
		
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
		_scroll =			new Gtk.ScrolledWindow();
		_headerBar =		new Adw.HeaderBar ();
		_box =				new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		_viewStack = 		new Adw.ViewStack (){hexpand=true, vexpand=true};
		_viewSwitcherBar =	new Adw.ViewSwitcherBar (){stack = _viewStack};
		
		this.set_content (_box);
		// HEADER BAR
		_box.append (_headerBar);
		_box.append(_scroll);
		_scroll.set_child(_viewStack);
		_box.append(_viewSwitcherBar);
	}

	private Gtk.Box				_box;
	private Gtk.ScrolledWindow	_scroll;
	private Adw.ViewSwitcherBar	_viewSwitcherBar;
	private Adw.ViewStack		_viewStack;
	private Adw.HeaderBar		_headerBar;
}

}
