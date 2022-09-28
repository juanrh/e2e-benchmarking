from setuptools import setup

setup(name='monitoring-benchmarks',
      version='0.1.0',
      packages=['monitoring-benchmarks'],
      install_requires = [
        'matplotlib>=3.5.3',
        'jupyter>=1.0.0',
        'ipykernel>=6.15.1',
        'pandas>=1.5.0',
      ])