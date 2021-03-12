all: zip

clean:
	rm -rf build

zip:
	mkdir -p build/html
	godot -v --export "HTML5" ../build/html/index.html project/project.godot
	cd build/html; zip web.zip *

