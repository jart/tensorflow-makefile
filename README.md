# TensorFlow 1.10 Makefile

```
sudo apt install \
  build-essential \
  gnutls-dev libncurses-dev \
  python2 python3-dev python3-pip \
  git rsync wget curl unzip htop pkg-config
wget https://github.com/bazelbuild/bazel/releases/download/0.15.0/bazel-0.15.0-installer-linux-x86_64.sh
chmod +x bazel-0.15.0-installer-linux-x86_64.sh
sudo ./bazel-0.15.0-installer-linux-x86_64.sh
git clone https://github.com/tensorflow/tensorflow
cd tensorflow
git checkout r1.10
blakefiler.py -c opt //tensorflow/core:{lib,protos_all_cc,framework_lite,ops,framework}
```
