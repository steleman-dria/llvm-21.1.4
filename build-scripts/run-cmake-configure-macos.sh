#!/bin/bash

llvm_version="21.1.4"
here="`pwd`"
topdir="`dirname ${here}`"
srcdir="${topdir}/llvm-${llvm_version}"
lldb_incdir="${srcdir}/lldb/include/lldb"
build_lldbincdir="${here}/include/lldb"
llvm_cmake_dir="${srcdir}/llvm"
outfile="${here}/llvm-configure.out"
cret=0
distro="`uname -s`"
lld_linker_flags="-Wl,-no_fixup_chains"
lld_linker_flags="${lld_linker_flags} -Wl,-undefined -Wl,dynamic_lookup"
lld_linker_flags="${lld_linker_flags} -Wl,--color-diagnostics=never"
exe_linker_flags="-Wl,-no_fixup_chains -Wl,--color-diagnostics=never"
linker_type="LLD"

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

export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/local/bin:/usr/sbin:${here}/bin:${PATH}"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/opt/diffutils/libexec/gnubin:${PATH}"
export PATH="/opt/homebrew/opt/ocaml/bin:${PATH}"
export PATH="${HOME}/.opam/default/bin:${PATH}"
export GMAKE="/opt/homebrew/bin/gmake"
export MAKE="${GMAKE}"
export CMAKE="/opt/homebrew/opt/cmake/bin/cmake"

export CC="/usr/bin/clang"
export CXX="/usr/bin/clang++"
export CFLAGS="-Wall -Wextra"
export CXXFLAGS="-Wall -Wextra"
export CPPFLAGS=""
export CMAKE_FLAGS=""

gsed="/opt/homebrew/bin/gsed"
cmakear="/usr/bin/ar"
python_executable="/opt/homebrew/bin/python3"
build_type="Release"

hb="/opt/homebrew"
hblib="${hb}/lib"
hbinc="${hb}/include"
libxml2="/opt/homebrew/Cellar/libxml2/2.13.8"
libxml2inc="${libxml2}/include"
libxml2lib="${libxml2}/lib"
libffi="/opt/homebrew/opt/libffi"
libffi_libdir="${libffi}/lib"
libffi_incdir="${libffi}/include"
ocaml="/opt/homebrew/opt/ocaml"
ocamllibdir="${ocaml}/lib"

lld_linker_flags="${lld_linker_flags} -Wl,-L,${hblib}"
lld_linker_flags="${lld_linker_flags} -Wl,-L,${libxml2lib}"
lld_linker_flags="${lld_linker_flags} -Wl,-L,${ffilibdir}"
lld_linker_flags="${lld_linker_flags} -Wl,-L,${ocamllibdir}"
lld_linker_flags="${lld_linker_flags} -Wl,-rpath,${hblib}"
lld_linker_flags="${lld_linker_flags} -Wl,-rpath,${libxml2lib}"
lld_linker_flags="${lld_linker_flags} -Wl,-rpath,${ffilibdir}"
lld_linker_flags="${lld_linker_flags} -Wl,-rpath,${ocamllibdir}"
linker_type="LLD"

cmake_install_rpath="${hblib};${libxml2lib};${ocamllib}"

prefix="/opt/llvm/${llvm_version}"
cmake_install_bindir="${prefix}/bin"
cmake_install_libdir="${prefix}/lib"
cmake_install_rpath="${cmake_install_rpath};${cmake_install_libdir}"
cmake_build_rpath="${here}/lib;${cmake_install_rpath}"
cmake_install_libexecdir="${prefix}/libexec"
cmake_install_incdir="${prefix}/include"
cmake_install_datadir="${prefix}/share"
llvm_targets="AArch64\;"

export PKG_CONFIG_PATH="${hblb}/pkgconfig:${libxml2lib}/pkgconfig:${ffilibdir}/pkgconfig"

cmake_flags="-DCMAKE_INSTALL_PREFIX=${prefix}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_LIBDIR=${cmake_install_libdir}"
cmake_flags="${cmake_flags} -DCMAKE_BUILD_TYPE=${build_type}"
cmake_flags="${cmake_flags} -DCMAKE_C_COMPILER=${CC}"
cmake_flags="${cmake_flags} -DCMAKE_CXX_COMPILER=${CXX}"
cmake_flags="${cmake_flags} -DCMAKE_C_FLAGS=${CFLAGS}"
cmake_flags="${cmake_flags} -DCMAKE_CXX_FLAGS=${CXXFLAGS}"
cmake_flags="${cmake_flags} -DCMAKE_C_FLAGS_RELEASE=${CFLAGS}"
cmake_flags="${cmake_flags} -DCMAKE_CXX_FLAGS_RELEASE=${CXXFLAGS}"
cmake_flags="${cmake_flags} -DCMAKE_LINKER_TYPE:STRING=${linker_type}"
cmake_flags="${cmake_flags} -DCMAKE_EXE_LINKER_FLAGS:STRING=${lld_linker_flags}"
cmake_flags="${cmake_flags} -DCMAKE_SHARED_LINKER_FLAGS:STRING=${lld_linker_flags}"
cmake_flags="${cmake_flags} -DCMAKE_MODULE_LINKER_FLAGS:STRING=${lld_linker_flags}"
cmake_flags="${cmake_flags} -DCMAKE_AR:FILEPATH=${cmakear}"
cmake_flags="${cmake_flags} -DCMAKE_C_STANDARD=11"
cmake_flags="${cmake_flags} -DCMAKE_CXX_STANDARD=17"
cmake_flags="${cmake_flags} -DCMAKE_C_EXTENSIONS:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_CXX_EXTENSIONS:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_BUILD_TYPE:STRING=${build_type}"
cmake_flags="${cmake_flags} -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_SUPPRESS_REGENERATION:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_BUILD_RPATH:STRING=${cmake_build_rpath}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_RPATH:STRING=${cmake_install_rpath}"

cmake_flags="${cmake_flags} -DCMAKE_INSTALL_BINDIR:FILEPATH=${cmake_install_bindir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_LIBDIR:FILEPATH=${cmake_install_libdir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_LIBEXECDIR:FILEPATH=${cmake_install_libexecdir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_INCLUDEDIR:FILEPATH=${cmake_install_incdir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_DATADIR:FILEPATH=${cmake_install_datadir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_DATAROOTDIR:FILEPATH=${cmake_install_datadir}"
cmake_flags="${cmake_flags} -DLLVM_TARGETS_TO_BUILD:STRING=${llvm_targets}"
cmake_flags="${cmake_flags} -DCMAKE_MAKE_PROGRAM:FILEPATH=${GMAKE}"
cmake_flags="${cmake_flags} -DCMAKE_ASM_COMPILER:FILEPATH=${CC}"
cmake_flags="${cmake_flags} -DLLVM_BUILD_TOOLS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_INCLUDE_TOOLS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_BUILD_TESTS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_INCLUDE_TESTS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_THREADS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_BUILD_32_BITS:BOOL=OFF"
cmake_flags="${cmake_flags} -DLLVM_BUILD_EXAMPLES:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_INCLUDE_EXAMPLES:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_EH:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_PIC:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_RTTI:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_WARNINGS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_PEDANTIC:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_ZLIB:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_FFI:BOOL=ON"
cmake_flags="${cmake_flags} -DFFI_INCLUDE_DIR:FILEPATH=${libffi_incdir}"
cmake_flags="${cmake_flags} -DFFI_LIBRARY_DIR:FILEPATH=${libffi_libdir}"
cmake_flags="${cmake_flags} -DLLVM_BUILD_STATIC:BOOL=OFF"
cmake_flags="${cmake_flags} -DLLVM_BUILD_LLVM_DYLIB:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_LINK_LLVM_DYLIB:BOOL=OFF"
cmake_flags="${cmake_flags} -DLLVM_COMPILER_IS_GCC_COMPATIBLE:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_PROJECTS='llvm;clang;clang-tools-extra;mlir;lldb;lld;polly'"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_RUNTIMES='compiler-rt;libcxxabi;libunwind;libcxx;openmp;libclc'"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_Z3_SOLVER:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_INSTALL_UTILS:BOOL=ON"
cmake_flags="${cmake_flags} -DMLIR_ENABLE_BINDINGS_PYTHON:BOOL=ON"
cmake_flags="${cmake_flags} -DLLDB_USE_SYSTEM_DEBUGSERVER:BOOL=ON"
cmake_flags="${cmake_flags} -DPython3_EXECUTABLE:FILEPATH=${python_executable}"
cmake_flags="${cmake_flags} -DLIBOMP_ARCH=AArch64"
cmake_flags="${cmake_flags} -DLIBOMP_LIB_TYPE=normal"
cmake_flags="${cmake_flags} -DLIBOMP_OMP_VERSION=50"
cmake_flags="${cmake_flags} -DOPENMP_ENABLE_LIBOMPTARGET=on"

${CC} --version
${CXX} --version

cat /dev/null > ${outfile}
echo "Running ${CMAKE} ${CMAKE_FLAGS} ${cmake_flags} ${llvm_cmake_dir}"
echo "Running ${CMAKE} ${CMAKE_FLAGS} ${cmake_flags} ${llvm_cmake_dir}" >> ${outfile} 2>&1
${CMAKE} ${CMAKE_FLAGS} ${cmake_flags} ${llvm_cmake_dir} >> ${outfile} 2>&1
cret=$?

if [ ${cret} -ne 0 ] ; then
  echo "CMake configuration failed."
  exit 1
fi

echo "Fixing bad compile flags from CMake ..."
echo "Fixing bad compile flags from CMake ..." >> ${outfile} 2>&1

listfile="/tmp/bad-compilerflags.$$"
cat /dev/null > ${listfile}

find . -type f -name "*.make" -print >> ${listfile} 2>&1

while read -r line
do
  cp -fp ${line} "${line}.orig"
  ${gsed} -i 's#-fvisibility-inlines-hidden##g' ${line}
  ${gsed} -i 's#-fvisibility=hidden##g' ${line}
  ${gsed} -i 's#-fvisibility=default##g' ${line}
  ${gsed} -i 's#-fno-semantic-interposition##g' ${line}
  touch -r "${line}.orig" -acm ${line}
  rm -f "${line}.orig"
done < ${listfile}

rm -f ${listfile}

echo "Fixing bad linker flags from CMake ..."
echo "Fixing bad linker flags from CMake ..." >> ${outfile} 2>&1

listfile="/tmp/link-relocations.$$"
cat /dev/null > ${listfile}

find . -type f -name "link.txt" -print >> ${listfile} 2>&1

while read -r line
do
  cp -fp ${line} "${line}.orig"
  ${gsed} -i 's#-Wl,-flat_namespace##g' ${line}
  ${gsed} -i 's#-Wl,-headerpad_max_install_names#-Wl,-undefined -Wl,dynamic_lookup#g' ${line}
  ${gsed} -i 's#-rdynamic##g' ${line}
  ${gsed} -i 's#-fno-semantic-interposition##g' ${line}
  ${gsed} -i 's#-fvisibility=hidden##g' ${line}
  ${gsed} -i 's#-fvisibility=default##g' ${line}
  ${gsed} -i 's#-fvisibility-inlines-hidden##g' ${line}
  ${gsed} -i 's#pthreadpool_interface#pthreadpool#g' ${line}
  ${gsed} -i 's#-Wl,-undefined -Wl,dynamic_lookup#-fuse-ld=lld -Wl,-undefined -Wl,dynamic_lookup#g' ${line}
  touch -r "${line}.orig" -acm ${line}
  rm -f "${line}.orig"
done < ${listfile}

rm -f ${listfile}

echo "Fixing OCaml linker crap ..."
echo "Fixing OCaml linker crap ..." >> ${outfile} 2>&1

listfile="/tmp/badocaml-link.$$"
cat /dev/null > ${listfile}

find . -type f -name "build.make" -print >> ${listfile} 2>&1
find . -type f -name "link.txt" -print >> ${listfile} 2>&1

while read -r line
do
  cp -fp ${line} "${line}.orig"
  ${gsed} -i 's#-l/opt/homebrew/lib/libz3.dylib#-L/opt/homebrew/lib -lz3#g' ${line}
  touch -r "${line}.orig" -acm ${line}
  rm -f "${line}.orig"
done < ${listfile}

rm -f ${listfile}

echo "CMake configuration finished."
echo "CMake configuration finished." >> ${outfile} 2>&1

