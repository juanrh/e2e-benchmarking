## Initial setup

Create virtual env

```bash
# or whatever you use
pyenv shell 3.10.6
python -m venv .venv
```

Install dependencies: `make deps`

## Daily usage

Open this in VsCode ina  top directory.  
Use [`Python: Select interpreter`](https://code.visualstudio.com/docs/python/environments#_work-with-python-interpreters) in VsCode to enable the virtual env in .venv. As a result VsCode activates the env for new shells. Actually manually use:

```bash
source .venv/bin/activate
deactivate
```

And use make for general tasks:

```bash
# install dependencies defined in setup.py in .venv
make deps
```

To create a notebook create a new file .ipynb in `e2e-benchmarking`.
