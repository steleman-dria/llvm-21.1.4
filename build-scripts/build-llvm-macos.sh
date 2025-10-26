#!/bin/bash

llvm_version="21.1.4"
here="`pwd`"
topdir="`dirname ${here}`"
srcdir="${topdir}/llvm-${llvm_version}"
llvm_cmake_dir="${srcdir}/llvm"
cret=0
distro="`uname -s`"

if [ "${distro}" != "Darwin" ] ; then
  echo "This cmake configure script only works on MacOS."
  exit 1
fi

if [ -e /opt/homebrew/bin/brew ] ; then
  /opt/homebrew/bin/brew shellenv >& /tmp/brewshellenv.$$
  source /tmp/brewshellenv.$$
  rm -f /tmp/brewshellenv.$$
fi

if [ -e /opt/homebrew/opt/opam/bin/opam ] ; then
  /opt/homebrew/opt/opam/bin/opam env >& /tmp/opamenv.$$
  source /tmp/opamenv.$$
  rm -f /tmp/opamenv.$$
fi

gsed="/opt/homebrew/bin/gsed"
python_executable="/opt/homebrew/bin/python3"
build_type="Release"
njobs="4"
output_file="${here}/llvm-build.log"

export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/local/bin:/usr/sbin:${here}/bin"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/opt/diffutils/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/opt/ocaml/bin:${PATH}"
export PATH="${HOME}/.opam/default/bin:${PATH}"
export LD_LIBRARY_PATH="${here}/lib"
export GMAKE="/opt/homebrew/bin/gmake"
export MAKE="${GMAKE}"
export CMAKE="/opt/homebrew/opt/cmake/bin/cmake"
export CC="/usr/bin/clang"
export CXX="/usr/bin/clang++"
export CFLAGS="-Wall -Wextra"
export CXXFLAGS="-Wall -Wextra"

${CC} --version
${CXX} --version

cat /dev/null > ${output_file}

echo "Building LLVM ..."
echo "gmake -j${njobs} >> ${output_file} 2>&1"
gmake -j${njobs} >> ${output_file} 2>&1
cret=$?

if [ ${cret} -eq 0 ] ; then
  echo "LLVM Build OK."
else
  echo "Building LLVM FAILED."
  exit 1
fi


