SRC=$(wildcard *.vala)
NAME=bin/waydroid-settings

all: $(NAME)
	echo $(SRC)

$(NAME): $(SRC)
	ninja install -C build

build:
	meson build --prefix=$(PWD)/bin --bindir="" --optimization=2

run: all
	./$(NAME)

run2: all
	GTK_DEBUG=interactive ./$(NAME)
