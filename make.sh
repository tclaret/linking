echo Create directories.
mkdir -p -v obj
mkdir -p -v lib/dir/sub
mkdir -p -v lib64/dir/sub
mkdir -p -v run

echo Build bar.so:
g++ -c -o obj/bar.o src/bar.cpp -fPIC
g++ -shared -o lib/dir/sub/bar.so obj/bar.o -Wl,-soname,bar.so

echo Build foo.so:
g++ -c -o obj/foo.o src/foo.cpp -fPIC
g++ -shared -o lib/dir/foo.so obj/foo.o -Wl,-soname,foo.so -Wl,-rpath,'$ORIGIN/sub' -Llib/dir/sub -l:bar.so

### Alternate foo that doesn't link to bar:
g++ -c -o obj/foo2.o src/foo2.cpp -fPIC
g++ -shared -o lib/dir/foo.so obj/foo2.o -Wl,-soname,foo.so

echo Build main.run:
g++ -c -o obj/main.o src/main.cpp
g++ -o run/main.run obj/main.o -Wl,-rpath,'$ORIGIN/../$LIB/dir' -Llib/dir -l:foo.so
