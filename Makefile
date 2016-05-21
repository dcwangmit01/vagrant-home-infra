config:
	j2 
deps:
	@if [ `uname` = "Darwin" ]; then \
	  if ! which brew; then \
	    echo "Installing Brew"; \
	    ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; \
	  fi; \
	  if ! which VirtualBox; then \
	    echo "Installing VirtualBox"; \
	    brew cask install virtualbox; \
	  fi; \
	  if ! which Vagrant; then \
	    echo "Installing Vagrant"; \
	    brew cask install vagrant; \
	  fi; \
	  if ! vagrant plugin list | grep vagrant-cachier; then \
	    echo "Installing vagrant-cachier"; \
	    vagrant plugin install vagrant-cachier; \
	  fi; \
	  if ! vagrant plugin list | grep vagrant-vbguest; then \
	    echo "Installing vagrant-vbguest"; \
	    vagrant plugin install vagrant-vbguest; \
	  fi; \
	  if ! which j2; then \
	    echo "Installing J2CLI"; \
	    pip install j2cli; \
	  fi; \
	fi

encrypt:
	secure encrypt

decrypt:
	secure decrypt

git-add-encrypted:
	find . -type f -name '*.encrypted.*' | xargs -n 1 git add
