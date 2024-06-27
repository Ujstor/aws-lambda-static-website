all: build

build:
	@echo "Building..."
	@if command -v templ > /dev/null; then \
			templ generate; \
	else \
		read -p "Go's 'templ' is not installed on your machine. Do you want to install it? [Y/n] " choice; \
		if [ "$$choice" != "n" ] && [ "$$choice" != "N" ]; then \
			go install github.com/a-h/templ/cmd/templ@latest; \
			templ generate; \
		else \
			echo "You chose not to install templ. Exiting..."; \
			exit 1; \
		fi; \
	fi
	@GOOS=linux GOARCH=amd64 go build -o bootstrap cmd/api/main.go

clean:
	@echo "Cleaning..."
	@rm -f bootstrap

.PHONY: all build clean
