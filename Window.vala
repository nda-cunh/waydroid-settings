namespace Wds{

class Window : Adw.ApplicationWindow{
	public Window(Gtk.Application app){
		Object(application: app, hexpand: true);
		init();
		

		// Pages
		_viewStack.add_titled_with_icon (new Wds.Settings (), "", "Settings", "emblem-system-symbolic");
		_viewStack.add_titled_with_icon (new Wds.Settings (), "", "Info", "emblem-system-symbolic");
		_viewStack.add_titled_with_icon (new Wds.Settings (), "", "Tools", "emblem-system-symbolic");
		
		//Header Bar Title (Select page)
		var toolsViewTitle = new Adw.ViewSwitcherTitle ();
		toolsViewTitle.set_stack (_viewStack);
            toolsViewTitle.notify.connect (() => {
                _viewSwitcherBar.set_reveal (toolsViewTitle.get_title_visible ());
            });
		_headerBar.set_title_widget (toolsViewTitle);
	}

	private void init(){
		_headerBar =		new Adw.HeaderBar ();
		_box =				new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		_viewStack = 		new Adw.ViewStack ();
		_viewSwitcherBar =	new Adw.ViewSwitcherBar (){stack = _viewStack};
		
		this.set_content (_box);
		// HEADER BAR
		_box.append (_headerBar);
		_box.append(_viewStack);
		_box.append(_viewSwitcherBar);
	}

	private Gtk.Box				_box;
	private Adw.ViewSwitcherBar	_viewSwitcherBar;
	private Adw.ViewStack		_viewStack;
	private Adw.HeaderBar		_headerBar;
}

}
