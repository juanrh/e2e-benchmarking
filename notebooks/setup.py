from setuptools import setup

setup(name='e2e-benchmarking',
      version='0.1.0',
      packages=['e2e-benchmarking'],
      install_requires = [
        'prometheus-api-client>=0.5.1',
        'matplotlib>=3.5.3',
        # https://pypi.org/project/jupyter/
        'jupyter>=1.0.0',
        'seaborn>=0.11.2',
        'ipykernel>=6.15.1',
      ],
      test_suite='nose.collector',
      tests_require=['nose'],
      zip_safe=False)