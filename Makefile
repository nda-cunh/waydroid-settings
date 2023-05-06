SRC=$(wildcard *.vala)
NAME=bin/waydroid-settings

all: $(NAME)
	echo $(SRC)

$(NAME): $(SRC)
	ninja install -C build

build:
	meson build --prefix=$(PWD)/bin --bindir=""

run: all
	./$(NAME)

run2: all
	GTK_DEBUG=interactive ./$(NAME)
