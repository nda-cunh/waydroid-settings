using Posix;
namespace FakeShell{
	void waydroid_set(string property, string option){
		var pid = fork();
		if (pid == 0){
			// execvp("waydroid", {"waydroid", "prop", "set" ,"persist." + property, option)});
			exit(0);
		}
		waitpid(pid, null, 0);
		print(@"$property est set to $option\n");
	}
	string waydroid_get(string property){
		StringBuilder str = new StringBuilder();
		int fds[2];

		pipe(fds);
		var pid = fork();
		if (pid == 0){
			close(fds[0]);
			dup2(fds[1], 1);
			// execvp("waydroid", {"waydroid", "prop", "get" ,"persist." + property});
			exit(0);
		}
		close(fds[1]);
		char c = '\0';
		while (read(fds[0], &c, 1) >= 1)
		{
			str.append_c(c);
		}
		waitpid(pid, null, 0);
		return "true";
		// return str.str;
	}
	// string system(string cmd){
		// StringBuilder str = new StringBuilder();
		// int fds_in[2];
		// int fds_out[2];
// 
		// pipe(fds_in);
		// write(fds_in[1], (char*)cmd, cmd.length);
		// pipe(fds_out);
		// 
// 
		// int pid = fork();
		// if (pid == 0){
			// close(fds_in[1]);
			// close(fds_out[0]);
			// dup2(fds_in[0], 0);
			// dup2(fds_out[1], 1);
			// execv("/bin/bash", {"bash"});
			// message("Error Fake shell");
			// exit(-1);
		// }
		// else{
			// close(fds_out[1]);
			// close(fds_in[0]);
			// close(fds_in[1]);
			// char c = '\0';
			// while (read(fds_out[0], &c, 1) >= 1)
			// {
				// print("[%c]\n", c);
				// str.append_c(c);
			// }
		// }
		// waitpid(pid, null, 0);
		// return str.str;
	// }
}
