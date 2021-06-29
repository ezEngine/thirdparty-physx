# Thirdparty Code: PhysX

This repository holds the headers required to build ezEngine with PhysX support enabled. See the documentation about the EZ [PhysX integration](http://ezengine.net/pages/docs/physics/physx-overview.html).

The precompiled libraries are stored as compressed packages as *Releases* in the [thirdparty repository](https://github.com/ezEngine/thirdparty). This is for size reasons, as this way only the necessary data can be downloaded selectively, because the GitHub provided CI machines have a storage size limit.

Currently the UWP builds use a slightly older version of PhysX.

To generate builds that link correctly with EZ, the settings of the PhysX build have to be tweaked in these files:

In **externals\cmakemodules\NvidiaBuildOptions.cmake**:

``` cmake
<cmakeSwitch name="NV_USE_STATIC_WINCRT" value="False" comment="Use the statically linked windows CRT" />
```

## Build Types

There are three build configurations:

### Shipping

This is a regular PhysX *release* build.

### Dev

This is a regular PhysX *checked* build.

### Debug

This is a *checked* build of PhysX, with debug options enabled.

In **buildtools\presets\public\vc16win64.xml** use these changes:

``` cmake
#SET(WINCRT_NDEBUG "/MD ${DISABLE_ITERATOR_DEBUGGING} ${CRT_NDEBUG_FLAG}")
#SET(CUDA_CRT_COMPILE_OPTIONS_NDEBUG "/MD")
SET(WINCRT_NDEBUG "/MDd ${CRT_DEBUG_FLAG}")
SET(CUDA_CRT_COMPILE_OPTIONS_NDEBUG "/MDd")
```
