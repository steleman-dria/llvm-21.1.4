LLVM 21.1.4 on MacOS 15.5 Sequoia
=================================

This is my fork of LLVM 21.1.4 from [https://llvm.org/](https://llvm.org/) on Fedora 41. It builds with MacOS's Apple clang version 17.0.0 (clang-1700.0.13.5).

The `main` branch is the canonical release from LLVM upstream, unmodified. The branch `llvm-21.1.4-macos-15.5-sequoia` is the MacOS branch containing my changes.

Build scripts are in the `build-scripts` directory in the `llvm-21.1.4-macos-15.5-sequoia` branch.

Build and Install Instructions:
-------------------------------

1. Clone this repo.
2. `%> mkdir build-llvm`
3. `%> mkdir install-llvm`
4. `%> cp ./llvm-21.1.4/build-scripts/run-cmake-configure-macos.sh ./build-llvm/`
5. `%> cp ./llvm-21.1.4/build-scripts/build-llvm-macos.sh ./build-llvm/`
6. `%> cp ./llvm-21.1.4/build-scripts/install-llvm-macos.sh ./build-llvm/`
7. `%> cd ./build-llvm`
8. `%> ./run-cmake-configure-macos.sh`
9. `%> ./build-llvm-macos.sh`
10.`%> ./install-llvm-macos.sh`

This build of LLVM will install in the `install-llvm` directory created above.

You will need to install a whole bunch of LLVM dependencies from brew:

- Python 3.13
- Python3 nanobind
- LibXML2
- Z3 solver
- CMake
- GNU Make
- GNU Toolkits
- OCaml and Opam - if you want the OCaml bindings.

The original [README.md](https://github.com/steleman/llvm-21.1.4/blob/main/README.md) file has been renamed to [LLVM.README.md](https://github.com/steleman/llvm-21.1.4/blob/llvm-21.1.4-macos-15.5-sequoia/LLVM.README.md).

I put this clone here because several of my other ports / forks at my Github depend on LLVM 21.1.4.

