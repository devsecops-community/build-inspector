set -e
mv /home/vagrant/sources.list /etc/apt/sources.list
mv /home/vagrant/environment /etc/environment
mv /home/vagrant/sshd /etc/pam.d/sshd
echo "Stopping puppet and chef"
service puppet stop
service chef-client stop
echo "Adding brightbox's ruby repository"
apt-add-repository ppa:brightbox/ruby-ng
echo "Updating apt"
apt-get update
echo "Installing dependencies"
apt-get install -y build-essential git-core zlib1g-dev libssl-dev \
  libreadline-dev libyaml-dev subversion maven2 gradle npm curl rdiff-backup \
  zip ruby2.2 ruby2.2-dev ruby-switch libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
  libcurl4-openssl-dev libffi-dev openjdk-7-jdk
echo "Switching to ruby2.2"
ruby-switch --set ruby2.2
