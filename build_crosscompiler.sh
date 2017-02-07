#/bin/sh
PARTICLE_DIR="$HOME/particle"
CROSSCOMPILE_DIR="$PARTICLE_DIR/particle-cc"
CROSSCOMPILE_SRC_DIR="$CROSSCOMPILE_DIR/src"
TARGET="i686-elf"
PREFIX="$CROSSCOMPILE_DIR"
export PATH="$PREFIX/bin:$PATH"
MAKE_THREADS="7"

GNU_MIRROR=http://gnu.mirrors.linux.ro

echo "Making src directory"
mkdir $PARTICLE_DIR
mkdir $CROSSCOMPILE_DIR
mkdir $CROSSCOMPILE_SRC_DIR

echo "Cleanup"
cd $CROSSCOMPILE_DIR
rm -rf src/build-*

set -e

BINUTILS_VERSION="2.27"
GCC_VERSION="6.2.0"
GMP_VERSION="6.1.1"
MPFR_VERSION="3.1.5"
MPC_VERSION="1.0.3"

#Downloading
cd $CROSSCOMPILE_SRC_DIR
BINUTILS_URL="$GNU_MIRROR/binutils/binutils-$BINUTILS_VERSION.tar.bz2"
GCC_URL="$GNU_MIRROR/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2"
GMP_URL="$GNU_MIRROR/gmp/gmp-$GMP_VERSION.tar.xz"
MPFR_URL="$GNU_MIRROR/mpfr/mpfr-$MPFR_VERSION.tar.xz"
MPC_URL="$GNU_MIRROR/mpc/mpc-$MPC_VERSION.tar.gz"

for URL in $BINUTILS_URL $GCC_URL $GMP_URL $MPFR_URL $MPC_URL
do
echo "Downloading: $URL"
wget -N $URL
done

echo "Building: binutils"
cd $CROSSCOMPILE_SRC_DIR
tar -xvjf binutils-$BINUTILS_VERSION.tar.bz2
mkdir build-binutils
cd build-binutils
../binutils-$BINUTILS_VERSION/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$MAKE_THREADS
make install

echo "Building GCC"
cd $CROSSCOMPILE_SRC_DIR
tar -xvjf gcc-$GCC_VERSION.tar.bz2

tar -xvJf gmp-$GMP_VERSION.tar.xz
tar -xvJf mpfr-$MPFR_VERSION.tar.xz
tar -xvzf mpc-$MPC_VERSION.tar.gz

mv gmp-$GMP_VERSION gcc-$GCC_VERSION/
mv mpfr-$MPFR_VERSION gcc-$GCC_VERSION/
mv mpc-$MPC_VERSION gcc-$GCC_VERSION/

mkdir build-gcc
cd build-gcc
../gcc-$GCC_VERSION/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c --without-headers
make all-gcc -j$MAKE_THREADS
make all-target-libgcc -j$MAKE_THREADS
make install-gcc
make install-target-libgcc

echo "Cleanup"
cd $CROSSCOMPILE_DIR
rm -rf src/build-*

echo "Adding symlinks"
cd $CROSSCOMPILE_DIR

echo "Adding to path"
export PATH="$CROSSCOMPILE_DIR/bin/:$PATH"
