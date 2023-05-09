
public class Main{
	public Main(){
		_app = new Adw.Application ("com.cosmos.waydroid", 0);
		_app.activate.connect(activate);
	}
	private void activate(){
		activate_css();
		var window = new Wds.Window(_app);
		window.present();
	}
	private void activate_css(){
		var provider = new Gtk.CssProvider();
		provider.load_from_data(css_data.data);
		Gtk.StyleContext.add_provider_for_display(Gdk.Display.get_default(), provider, 0);
	}
	private int run(string []args){
		return _app.run(args);
	}
	public static int main(string []args){
	
		var app = new Main();
		return app.run(args);	
	}

	private Gtk.Application _app;
}

const string css_data = """
frame{
	background-color:black;
	padding:12px;
	border-radius:20px;
}	
""";
