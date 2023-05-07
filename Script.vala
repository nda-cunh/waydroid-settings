namespace Wds{

	public class Script: Gtk.Box{
	public Script(){
		Object(orientation: Gtk.Orientation.VERTICAL);
		this.init();
		this.append(new Terminal());
	}
	private void init(){
		// _window_block = new WindowBlock();
		// _general_block = new GeneralBlock();
	}
	// private GeneralBlock	_general_block; 
	// private WindowBlock		_window_block;
}


public class Terminal : Gtk.Box{
	public Terminal(){
		Object(orientation: Gtk.Orientation.VERTICAL);
		this.init();
		this.append(new Gtk.Label("Terminal:"));
		this.append(_text);
		run_ls();
	}
	public void run_ls(){
		_buffer.set_text("LS".data);	
	}
	private void init(){
		_buffer = new Gtk.EntryBuffer(null);
		_text = new Gtk.Text.with_buffer(_buffer);
	}
	private Gtk.EntryBuffer	_buffer;
	private Gtk.Text		_text;
}

}
