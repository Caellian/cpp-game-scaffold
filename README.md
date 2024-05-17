# C++ Game Engine Scaffolding

This template aims to remove most of the boilerplate project setup from
developing a C++ game (engine) by ensuring a completely reproducible build
environment.

This is done through use of CMake which is utilized to clone all dependencies a
game (engine) requires in most scenarios and then some extras you might not
think of until you need them.

## Included libraries

The following libraries are cloned/downloaded by
[`thirdparty/CMakeLists.txt`](./thirdparty/CMakeLists.txt) and ready to use out
of the box:

### Core

- ECS system: [flecs](https://github.com/SanderMertens/flecs) (MIT)
- Lua: [LuaJIT](https://luajit.org/) (MIT)

### Rendering

- DirectX 12
  - [Agility SDK](https://devblogs.microsoft.com/directx/directx12agility/)
  - [Memory Allocator](https://github.com/GPUOpen-LibrariesAndSDKs/D3D12MemoryAllocator)
  - [Shader Compiler](https://github.com/microsoft/DirectXShaderCompiler)
- Debugging GUI: [imgui](https://github.com/ocornut/imgui) (MIT)
  - This library is vendored on first configuration as it's commonly modified by
    users.

### System

- Device input: ~~[OIS](https://github.com/wgois/OIS)~~ (Zlib)
  - TODO: Find a replacement that isn't SDL. CrossWindow?

### Utilities

- CPU information: [cpu_features](https://github.com/google/cpu_features) (Apache 2.0)
- String manipulation: [bstrlib](https://github.com/websnarf/bstrlib) (BSD-3-Clause)
- Hot reloading: [cr](https://github.com/fungos/cr) (MIT)

### Formats

- [cJSON](https://github.com/DaveGamble/cJSON) (MIT)
- [cgltf](https://github.com/jkuhlmann/cgltf) (MIT)
  - TODO: Replace with [tiny_gltf](https://github.com/syoyo/tinygltf) (MIT)?

### Preprocessing

- [FontStash](https://github.com/memononen/fontstash) (Zlib)

### Debugging

- [MMGR](http://www.FluidStudios.com) by Paul Nettle (Custom license)
  - Modified to use C++ style casts and `uintptr_t` instead of `unsigned int`
    (sufficient only for 32-bit pointers)

### TODO

- Compression
  - lz4
  - zlib
  - zstd?
- Utils
  - [murmurhash3](https://github.com/aappleby/smhasher)
  - [Nothings](https://github.com/nothings/stb) (MIT/Public domain)
  - [frozen](https://github.com/serge-sans-paille/frozen) for static maps
- NVidia
  - nvapi
- OpenGL
  - GLEW or some [other loader](https://www.khronos.org/opengl/wiki/OpenGL_Loading_Library)
- Vulkan
  - SDK
  - Memory Allocator
  - SPRIV crosscompiler
- [soloud](https://solhsa.com/soloud/) or another audio engine
- Window abstraction
  - [GLFW](https://github.com/glfw/glfw) for desktop
  - [GLFM](https://github.com/brackeen/glfm) for mobile
  - [CrossWindow](https://github.com/alaingalvan/CrossWindow)
- Task Scheduler
  - The Forge uses [TaskScheduler](https://github.com/SergeyMakeev/TaskScheduler) (unmaintained)
  - alternative is [concurrencpp](https://github.com/David-Haim/concurrencpp) (popular, maintained)
  - or [FiberTaskingLib](https://github.com/RichieSams/FiberTaskingLib) which is more similar to TaskScheduler
- Formats
  - DDS image format: [tiny_dds](https://github.com/DeanoC/tiny_dds) or [dds_image](https://github.com/spnda/dds_image)
  - ~~[tiny_imageformat](https://github.com/DeanoC/tiny_imageformat)~~ > Nothings image
  - KTX image format: [tiny_ktx](https://github.com/DeanoC/tiny_ktx)
  - XML: [TinyXML2](https://github.com/leethomason/tinyxml2)
  - [tiny_obj_loader](https://github.com/syoyo/tinyobjloader)
  - Nothings vorbis
- SIMD & linear algebra
  - [volk](https://github.com/gnuradio/volk)
  - [Vectormath](https://github.com/glampert/vectormath)
- Logging & formatting
  - spdlog
  - fmt
- Debugging
  - [RenderDoc](https://renderdoc.org/)
  - [MTuner SDK](https://rudjigames.github.io/MTuner/mtuner_sdk/) memory profiler
  - Microsoft Windows [PixEvents](https://github.com/microsoft/PixEvents)? Something cross-platform?
- Preprocessing
  - mcpp preprocessor?

## License

This project is licensed under `Apache 2.0`/`MIT`/`Zlib` terenary license.<br/>
Copies of the licenses can be found in the root directory.

It republishes MMGR which has a custom license (see
[`thirdparty/mmgr/README.md`](./thirdparty/mmgr/README.md)).

All other used libraries are not redistributed and instead get downloaded at
project configuration time. See their respective websites or repositories linked
in this document for more details.<br/>
Most libraries use permissive licenses however and can be safely included in
commercial code, but check the licenses of the libraries you end up using. I
take no responsibility for any issues that may arise from depending on any of
them, be it with intent (e.g. by enabling them in configuration) or by accident
(e.g. configuration doesn't exclude their sources/binaries and you end up
including them in your build).
