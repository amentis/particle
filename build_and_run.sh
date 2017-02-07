#/bin/sh
set -e

echo "Cleaning"
make clean
echo "Building"
make
echo "Running"
qemu-system-i386 -kernel build/particle
echo "Cleaning"
make clean
