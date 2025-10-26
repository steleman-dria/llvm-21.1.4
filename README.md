LLVM 21.1.4 on Fedora 41
========================

This is my fork of LLVM 21.1.4 from [https://llvm.org/](https://llvm.org/) on Fedora 41. It builds with Fedora's GCC 14.3.1.

The `main` branch is the canonical release from LLVM upstream, unmodified. The branch `llvm-21.1.4-fc41` is the Fedora 41 branch containing my changes.

Build scripts are in the `build-scripts` directory in the `llvm-21.1.4-fc41` branch.

Build and Install Instructions:
-------------------------------

1. Clone this repo.
2. `%> mkdir build-llvm`
3. `%> mkdir install-llvm`
4. `%> cp ./llvm-21.1.4/build-scripts/run-cmake-configure-linux.sh ./build-llvm/`
5. `%> cp ./llvm-21.1.4/build-scripts/build-llvm-linux.sh ./build-llvm/`
6. `%> cp ./llvm-21.1.4/build-scripts/install-llvm-linux.sh ./build-llvm/`
7. `%> cd ./build-llvm`
8. `%> ./run-cmake-configure-linux.sh`
9. `%> ./build-llvm-linux.sh`
10.`%> ./install-llvm-linux.sh`

This build of LLVM will install in the `install-llvm` directory created above.

The original [README.md](https://github.com/steleman/llvm-21.1.4/blob/main/README.md) file has been renamed to [LLVM.README.md](https://github.com/steleman/llvm-21.1.4/blob/llvm-21.1.4-fc41/LLVM.README.md).

I put this clone here because several of my other ports / forks at my Github depend on LLVM 21.1.4.

You can find the RPM spec files for Fedora 41 in the same `build-scripts` directory.

