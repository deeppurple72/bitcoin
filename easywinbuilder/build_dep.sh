set -o errexit

echo "$(path)"

if [ -d "../src/leveldb" ]; then
    echo leveldb...
    cd ../src/leveldb
    make memenv_test TARGET_OS=OS_WINDOWS_CROSSCOMPILE
    echo
    cd ../../easywinbuilder
fi

cd ../libs

echo  openssl...
cd openssl-1.0.1e
./config
make
cd ..
echo

echo db...
cd db-4.8.30.NC
cd build_unix
../dist/configure --disable-replication --enable-mingw --enable-cxx # --disable-shared
sed -i 's/typedef pthread_t db_threadid_t;/typedef u_int32_t db_threadid_t;/g' db.h  # workaround, see https://bitcointalk.org/index.php?topic=45507.0
make
cd ..
cd ..
echo

echo prepare miniupnpc sources...
cd miniupnpc-1.8
sed -i.bak 's/\$(CC) -enable-stdcall-fixup/\$(CC) -Wl,-enable-stdcall-fixup/g' Makefile.mingw  # workaround, see http://stackoverflow.com/questions/13227354/warning-cannot-find-entry-symbol-nable-stdcall-fixup-defaulting
sed -i.bak 's/all:	init upnpc-static upnpc-shared testminixml libminiupnpc.a miniupnpc.dll/all:	init upnpc-static/g' Makefile.mingw  # only need static, rest is not compiling
#make -f Makefile.mingw  # later, needs windows shell
cd ..
