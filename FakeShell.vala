public struct StatusWaydroid {
	StatusWaydroid(bool session, bool container, bool freeze) {
		this.session = session;
		this.container = container;
		this.freeze = freeze;
	}
	bool session;
	bool container;
	bool freeze;
}

namespace FakeShell {
	
	void waydroid_set(string property, string option){
		Process.spawn_command_line_sync(@"waydroid prop set persist.waydroid.$property $option");
		message(@"$property is set to $option\n");
	}

	string waydroid_get (string property) {
		string contents;

		Process.spawn_command_line_sync(@"waydroid prop get persist.waydroid.$property", out contents);
		contents._strip();
		message(@"$property is get to $(contents)\n");
		return contents;
	}

	StatusWaydroid waydroid_status() {
		var output = system("waydroid status");
		StatusWaydroid info = {false};

		foreach (unowned var i in output.split("\n")) {
 			if ("Session:" in i){
				if("RUNNING" in i)
					info.session = true;
			}
			//TODO ADD HERE OTHER STATUS
			if ("Container" in i){
				if("RUNNING" in i)
					info.container = true;
				if("FROZZEN" in i)
					info.freeze = true;
			}
		}
		return info;
	}

	string system (string cmd) {
		string result;
		Process.spawn_sync(null, {"/bin/bash", "bash"}, null, SpawnFlags.CHILD_INHERITS_STDIN, null, out result, null);
		return result;
	}
}
