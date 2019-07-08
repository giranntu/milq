######################################
# INSTALL OPENCV ON UBUNTU OR DEBIAN #
######################################

# |          THIS SCRIPT IS TESTED CORRECTLY ON          |
# |------------------------------------------------------|
# | OS               | OpenCV       | Test | Last test   |
# |------------------|--------------|------|-------------|
# | Ubuntu 18.04 LTS | OpenCV 4.1.0 | OK   | 22 Jun 2019 |
# | Debian 9.9       | OpenCV 4.1.0 | OK   | 22 Jun 2019 |
# |----------------------------------------------------- |
# | Ubuntu 18.04 LTS | OpenCV 3.4.2 | OK   | 18 Jul 2018 |
# | Debian 9.5       | OpenCV 3.4.2 | OK   | 18 Jul 2018 |


# SCRIPT OPTIONS

OPENCV_VERSION='4.1.0'    # Version to be installed
# OPENCV_CONTRIB='NO'       # Install OpenCV's extra modules


# 1. KEEP UBUNTU OR DEBIAN UP TO DATE

apt-get -y update
# sudo apt-get -y upgrade       # Uncomment to install new versions of packages currently installed
# sudo apt-get -y dist-upgrade  # Uncomment to handle changing dependencies with new vers. of pack.
# sudo apt-get -y autoremove    # Uncomment to remove packages that are now no longer needed


# 2. INSTALL THE DEPENDENCIES

# Build tools:
apt-get install -y build-essential cmake git

# GUI (if you want GTK, change 'qt5-default' to 'libgtkglext1-dev' and remove '-DWITH_QT=ON'):
apt-get install -y qt5-default libvtk6-dev

# Media I/O:
apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev \
                        libopenexr-dev libgdal-dev

# Video I/O:
apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev \
                        libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \
                        libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

# Parallelism and linear algebra libraries:
apt-get install -y libtbb-dev libeigen3-dev

# Python:
apt-get install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy

# Java:
apt-get install -y ant default-jdk

# Documentation:
apt-get install -y doxygen 


# 3. INSTALL THE LIBRARY and OPENCV_CONTRIB
echo "Downloading OpenCV Modules..."
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout 4.1.0
cd ..


apt-get install -y unzip wget
wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
mv opencv-${OPENCV_VERSION} OpenCV
cd OpenCV && mkdir build && cd build

echo "Setting CUDA Paths"
export LD_LIBRARY_PATH=/usr/local/cuda/lib
export PATH=$PATH:/usr/local/cuda/bin
echo "Configure OpenCV Build"

cmake -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_NVCUVID=ON -D FORCE_VTK=ON -D WITH_XINE=ON -D WITH_CUDA=ON -D WITH_OPENGL=ON -D WITH_TBB=ON -D WITH_OPENCL=ON -D CMAKE_BUILD_TYPE=RELEASE -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES --expt-relaxed-constexpr" -D WITH_GDAL=ON -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules/ -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D CXXFLAGS="-std=c++11" -DCMAKE_CXX_COMPILER=g++-6 -DCMAKE_C_COMPILER=gcc-6 ..


###########################################
#cmake -D WITH_CUDA=ON \
#    -D ENABLE_FAST_MATH=1 \
#    -D CUDA_FAST_MATH=1 \
#     -D WITH_CUBLAS=1 \
#     -DWITH_QT=ON \
#     -DWITH_OPENGL=ON \
#     -DFORCE_VTK=ON \
#     -DWITH_TBB=ON \
#     -DWITH_GDAL=ON \
#     -DWITH_XINE=ON \
#     -DBUILD_EXAMPLES=ON \
#     -D WITH_OPENCL=ON \
#     -D WITH_NVCUVID=ON \ 
#     -D WITH_GDAL=ON .. \ 
############################################

echo "Start OpenCV Build"
make -j "$(nproc)"
echo "Install OpenCV Build"

make install
bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
ldconfig

