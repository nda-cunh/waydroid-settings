
public class Main{
	public Main(){
		_app = new Gtk.Application ("com.cosmos.waydroid", 0);
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
headerbar label{
	font-weight: 700;
	font-size=12px;
}

.title{
	margin-top:5px;
	margin-left:15px;
}
.adwclamp{
	#background-color:white;
	margin:10px;
  box-shadow: 0 0 5px 1px rgba(0, 0, 0, 0.1);
	border-radius:15px;
.adwclamp spinbutton{
	border-radius:10px;
}
}
""";
