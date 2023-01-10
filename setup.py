#Create a package from the src folder
from setuptools import setup, find_packages

with open("README.md", 'r') as f:
    long_description = f.read()


setup(
    name='src',
    version='1.0',
    description='src',
    author='Kevin Ly',
    author_email='k.y@hotmail.ch',
    where=['src']  #same as name

)