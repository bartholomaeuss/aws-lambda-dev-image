# AWS LAMBDA DEV IMAGE

### Prerequisite

Add installation path of `pycharm64.exe` to your `PATH` variable.
As of now the code is tested only on windows local machines.

```bash
./hello_world.sh
```

### Windows

```bash
./provide_container.sh
```

```bash
./init_remote_ide.sh
```

### More

```
ssh -p 2223 -i ~/.ssh/<key> <user>@localhost
```

Add `/var/runtime` to `Interpreter Paths` for your python interpreter in question in your IDE. 

See the official
[docker build](https://docs.docker.com/engine/reference/commandline/build/)
documentation.
See also the official
[docker run](https://docs.docker.com/engine/reference/commandline/run/)
documentation.
