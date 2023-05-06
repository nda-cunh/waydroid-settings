
public class Main{
	public Main(){
		_app = new Gtk.Application ("com.cosmos.waydroid", 0);
		_app.activate.connect(activate);
	}
	private void activate(){
		var window = new Wds.Window(_app);
		window.present();
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
