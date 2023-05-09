using Posix;
public struct StatusWaydroid{
	StatusWaydroid(bool session, bool container, bool freeze){
	this.session = session;
	this.container = container;
	this.freeze = freeze;
	}
	bool session;
	bool container;
	bool freeze;
}

namespace FakeShell{
	
	void waydroid_set(string property, string option){
		var pid = fork();
		if (pid == 0){
			execvp("waydroid", {"waydroid", "prop", "set" ,"persist.waydroid." + property, option});
			exit(0);
		}
		waitpid(pid, null, 0);
		message(@"$property est set to $option\n");
	}

	string waydroid_get(string property){
		StringBuilder str = new StringBuilder();
		int fds[2];

		pipe(fds);
		var pid = fork();
		if (pid == 0){
			close(fds[0]);
			dup2(fds[1], 1);
			execvp("waydroid", {"waydroid", "prop", "get" ,"persist.waydroid." + property});
			exit(0);
		}
		close(fds[1]);
		char c = '\0';
		while (read(fds[0], &c, 1) >= 1)
			str.append_c(c);
		waitpid(pid, null, 0);
		message(@"$property est get to $(str.str)\n");
		return str.str.strip();
	}

	StatusWaydroid waydroid_status(){
		var output = system("waydroid status");
		StatusWaydroid info = {false};

		foreach (var i in output.split("\n")){
			if ("Session:" in i){
				if("STOPPED" in i)
					info.session = false;
				else
					info.session = true;
			}
			//TODO ADD HERE OTHER STATUS
			if ("Session:" in i){
				if("STOPPED" in i)
					info.session = false;
				else
					info.session = true;
			}
		}
		return info;
	}

	string system(string cmd){
		StringBuilder str = new StringBuilder();
		int fds_in[2];
		int fds_out[2];

		pipe(fds_in);
		write(fds_in[1], (char*)cmd, cmd.length);
		pipe(fds_out);
		

		int pid = fork();
		if (pid == 0){
			close(fds_in[1]);
			close(fds_out[0]);
			dup2(fds_in[0], 0);
			dup2(fds_out[1], 1);
			execv("/bin/bash", {"bash"});
			warning("Error Fake shell");
			exit(-1);
		}
		else{
			close(fds_out[1]);
			close(fds_in[0]);
			close(fds_in[1]);
			char c = '\0';
			while (read(fds_out[0], &c, 1) >= 1)
			{
				str.append_c(c);
			}
		}
		waitpid(pid, null, 0);
		return str.str;
	}
}
