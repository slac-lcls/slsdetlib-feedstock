if [ -z ${CONDA_BUILD+x} ]; then
    source /sdf/group/lcls/ds/ana/sw/conda_bld/valmar/conda-bld/debug_1729803287650/work/build_env_setup.sh
fi
# SPDX-License-Identifier: LGPL-3.0-or-other
# Copyright (C) 2021 Contributors to the SLS Detector Package

mkdir build
mkdir install
cd build
cmake .. \
      -DCMAKE_PREFIX_PATH=$CONDA_PREFIX \
      -DCMAKE_INSTALL_PREFIX=install \
      -DSLS_USE_TEXTCLIENT=ON \
      -DSLS_USE_RECEIVER=ON \
      -DSLS_USE_GUI=OFF \
      -DSLS_USE_MOENCH=OFF \
      -DSLS_USE_TESTS=ON \
      -DSLS_USE_PYTHON=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DSLS_USE_HDF5=OFF\
     
NCORES=$(getconf _NPROCESSORS_ONLN)
echo "Building using: ${NCORES} cores"
cmake --build . -- -j${NCORES}
cmake --build . --target install

CTEST_OUTPUT_ON_FAILURE=1 ctest -j 1

mkdir -p $PREFIX/lib
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/include/sls
# mkdir $PREFIX/include/slsDetectorPackage

#Shared and static libraries
cp ${SRC_DIR}/build/install/lib/* $PREFIX/lib/

#Binaries
cp ${SRC_DIR}/build/install/bin/sls_detector_acquire $PREFIX/bin/.
cp ${SRC_DIR}/build/install/bin/sls_detector_get $PREFIX/bin/.
cp ${SRC_DIR}/build/install/bin/sls_detector_put $PREFIX/bin/.
cp ${SRC_DIR}/build/install/bin/sls_detector_help $PREFIX/bin/.
cp ${SRC_DIR}/build/install/bin/slsReceiver $PREFIX/bin/.
cp ${SRC_DIR}/build/install/bin/slsMultiReceiver $PREFIX/bin/.


cp ${SRC_DIR}/build/install/include/sls/* $PREFIX/include/sls
cp -rv ${SRC_DIR}/build/install/share $PREFIX
