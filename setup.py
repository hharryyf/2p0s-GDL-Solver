from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize(["solver_c.pyx", "board.pyx"])
)