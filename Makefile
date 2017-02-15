config:
	j2 -f yaml Vagrantfile.j2 config.yaml > Vagrantfile
	j2 -f yaml docker-compose.yaml.j2 config.yaml > docker-compose.yaml
	j2 -f yaml conf/nginx_sites.conf.j2 config.yaml > conf/nginx_sites.conf
	j2 -f yaml conf/authorized_keys.j2 config.yaml > conf/authorized_keys

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
            pip install j2cli[yaml]; \
	  fi; \
	fi

tools:
	@# install secure: a gpg multiparty encryption wrapper
	if ! which secure; then \
	    curl -s https://raw.githubusercontent.com/dcwangmit01/secure/master/install.sh | bash; \
	fi

encrypt:
	secure encrypt

decrypt:
	secure decrypt

git-add-encrypted:
	find . -type f -name '*.encrypted.*' | xargs -n 1 git add
