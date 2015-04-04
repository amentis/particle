#/bin/sh
echo "Cleaning"
make clean
echo "Building"
make
echo "Running"
qemu-system-i386 -kernel particle
