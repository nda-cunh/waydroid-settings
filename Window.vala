namespace Wds{

class Window : Adw.ApplicationWindow{
	public Window(Gtk.Application app){
		Object(application: app, hexpand: true);

		_headerBar = new Adw.HeaderBar ();
		_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		_viewStack = 	new Adw.ViewStack ();
		_viewSwitcherBar = new Adw.ViewSwitcherBar ();
		this.set_content (_box);
		_box.append (_headerBar);
		_box.append(_viewStack);
		_box.append(_viewSwitcherBar);

		var page1 = _viewStack.add_titled (new Wds.Settings (), "discord", "Settings");
		page1.set_icon_name ("emblem-system-symbolic");
		var page2 = _viewStack.add_titled (new Gtk.Label("TODO"), "GAMES", "Script");
		page2.set_icon_name ("emblem-system-symbolic");
		var page3 = _viewStack.add_titled (new Gtk.Label("TODO"), "GAMES", "Tools");
		page3.set_icon_name ("emblem-system-symbolic");

		_viewSwitcherBar.set_stack (_viewStack);

		_viewSwitcherBar.set_stack (_viewStack);
		var toolsViewTitle = new Adw.ViewSwitcherTitle ();
		toolsViewTitle.set_stack (_viewStack);
            toolsViewTitle.notify.connect (() => {
                _viewSwitcherBar.set_reveal (toolsViewTitle.get_title_visible ());
            });
		_headerBar.set_title_widget (toolsViewTitle);
	}

	private Gtk.Box				_box;
	private Adw.ViewSwitcherBar	_viewSwitcherBar;
	private Adw.ViewStack		_viewStack;
	private Adw.HeaderBar		_headerBar;
}

}
