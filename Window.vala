namespace Wds{

class Window : Gtk.ApplicationWindow{
	public Window(Gtk.Application app){
		Object(application: app);
		_notebook = new Gtk.Notebook();
		_notebook.append_page (new Wds.Settings(), new Gtk.Label("Settings"));
		this.set_child(_notebook);
		base.hexpand=true;
	}

	private Gtk.Notebook _notebook;
}

}
