ez_cmake_init()

ez_requires_physx()

set(PHYSX_VERSION "4.1.2.29882248")
set(PHYSX_BINARY "")
set(PHYSX_BIN_DEBUG "debug")
set(PHYSX_BIN_DEV "dev")
set(PHYSX_BIN_SHIPPING "shipping")
set(PHYSX_URL "")

if (CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")

    # use the older version for UWP
    set(PHYSX_VERSION "4.1.1.27006925")

    set(PHYSX_BIN_DEBUG "debug")
    set(PHYSX_BIN_DEV "release")
    set(PHYSX_BIN_SHIPPING "release")

    if (EZ_CMAKE_ARCHITECTURE_ARM)
        set(PHYSX_BINARY "uwp.arm_64.vc141")
        set(PHYSX_URL "https://github.com/ezEngine/thirdparty/releases/download/PhysX-4.1.2/PhysX_4.1.1.27006925_uwp.arm_64.vc141.7z")
    else()
        set(PHYSX_BINARY "uwp.x86_64.vc141")
        set(PHYSX_URL "https://github.com/ezEngine/thirdparty/releases/download/PhysX-4.1.2/PhysX_4.1.1.27006925_uwp.x86_64.vc141.7z")
        endif()
        
    elseif (CMAKE_SYSTEM_NAME STREQUAL "Windows")
        
        if (EZ_CMAKE_ARCHITECTURE_ARM)
        message(FATAL_ERROR "Physx does not support ARM on desktop.")
    else()
        set(PHYSX_BINARY "win.x86_64.vc142.md")
        set(PHYSX_URL "https://github.com/ezEngine/thirdparty/releases/download/PhysX-4.1.2/PhysX_4.1.2.29882248_win.x86_64.vc142.md.7z")
    endif()

else()
    message(FATAL_ERROR "Unsupported or not implemented PhysX platform.")
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(PHYSX_LIB_SUFFIX "_64.lib")
    set(PHYSX_DLL_SUFFIX "_64.dll")
else()
    set(PHYSX_LIB_SUFFIX "_32.lib")
    set(PHYSX_DLL_SUFFIX "_32.dll")

    message(FATAL_ERROR "Unsupported or not implemented PhysX platform.")
endif()

set(EZ_PHYSX_SDK ${CMAKE_CURRENT_SOURCE_DIR}/${PHYSX_VERSION})

set (PHYSX_BINS "${EZ_PHYSX_SDK}/PhysX/bin")

set (PHYSX_BIN_DIR "${PHYSX_BINS}/${PHYSX_BINARY}")
set (PHYSX_INC_DIR "${EZ_PHYSX_SDK}/PhysX/Include")
set (PXSHARED_INC_DIR "${EZ_PHYSX_SDK}/PxShared/include")

set (PX_LOCAL_MARKER "${PHYSX_BINS}/${PHYSX_BINARY}.extracted")

if (NOT EXISTS "${PX_LOCAL_MARKER}")

    set(ZIP_APP "${CMAKE_SOURCE_DIR}/Data/Tools/Precompiled/7za.exe")

    if (NOT EXISTS "${PHYSX_BINS}/${PHYSX_BINARY}.7z")
        file(DOWNLOAD ${PHYSX_URL} "${PHYSX_BINS}/${PHYSX_BINARY}.7z" SHOW_PROGRESS)
    endif()

    message(STATUS "Extracting '${PHYSX_BINARY}.7z'...")  
    execute_process(COMMAND ${ZIP_APP} 
        x "${PHYSX_BINS}/${PHYSX_BINARY}.7z"
        -aoa
        WORKING_DIRECTORY "${PHYSX_BINS}"
        COMMAND_ERROR_IS_FATAL ANY)

    file(TOUCH ${PX_LOCAL_MARKER})

endif()

file(REMOVE "${PHYSX_BINS}/${PHYSX_BINARY}.7z")

add_library(ezPhysX::Foundation SHARED IMPORTED GLOBAL)
set_target_properties(ezPhysX::Foundation PROPERTIES IMPORTED_LOCATION_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXFoundation${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Foundation PROPERTIES IMPORTED_LOCATION_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXFoundation${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Foundation PROPERTIES IMPORTED_LOCATION_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXFoundation${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Foundation PROPERTIES IMPORTED_IMPLIB_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXFoundation${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Foundation PROPERTIES IMPORTED_IMPLIB_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXFoundation${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Foundation PROPERTIES IMPORTED_IMPLIB_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXFoundation${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Foundation PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PXSHARED_INC_DIR}")
ez_uwp_mark_import_as_content(ezPhysX::Foundation)

add_library(ezPhysX::PVD STATIC IMPORTED GLOBAL)
set_target_properties(ezPhysX::PVD PROPERTIES IMPORTED_LOCATION_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXPvdSDK_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::PVD PROPERTIES IMPORTED_LOCATION_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXPvdSDK_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::PVD PROPERTIES IMPORTED_LOCATION_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXPvdSDK_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::PVD PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PXSHARED_INC_DIR}")
target_link_libraries(ezPhysX::PVD INTERFACE ezPhysX::Foundation)

add_library(ezPhysX::Common SHARED IMPORTED GLOBAL)
set_target_properties(ezPhysX::Common PROPERTIES IMPORTED_LOCATION_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXCommon${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Common PROPERTIES IMPORTED_LOCATION_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXCommon${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Common PROPERTIES IMPORTED_LOCATION_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXCommon${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Common PROPERTIES IMPORTED_IMPLIB_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXCommon${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Common PROPERTIES IMPORTED_IMPLIB_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXCommon${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Common PROPERTIES IMPORTED_IMPLIB_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXCommon${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Common PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PHYSX_INC_DIR}")
target_link_libraries(ezPhysX::Common INTERFACE ezPhysX::Foundation)
ez_uwp_mark_import_as_content(ezPhysX::Common)

add_library(ezPhysX::PhysX SHARED IMPORTED GLOBAL)
set_target_properties(ezPhysX::PhysX PROPERTIES IMPORTED_LOCATION_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysX${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::PhysX PROPERTIES IMPORTED_LOCATION_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysX${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::PhysX PROPERTIES IMPORTED_LOCATION_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysX${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::PhysX PROPERTIES IMPORTED_IMPLIB_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysX${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::PhysX PROPERTIES IMPORTED_IMPLIB_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysX${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::PhysX PROPERTIES IMPORTED_IMPLIB_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysX${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::PhysX PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PHYSX_INC_DIR}")
target_link_libraries(ezPhysX::PhysX INTERFACE ezPhysX::Common)
ez_uwp_mark_import_as_content(ezPhysX::PhysX)

add_library(ezPhysX::Cooking SHARED IMPORTED GLOBAL)
set_target_properties(ezPhysX::Cooking PROPERTIES IMPORTED_LOCATION_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXCooking${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Cooking PROPERTIES IMPORTED_LOCATION_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXCooking${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Cooking PROPERTIES IMPORTED_LOCATION_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXCooking${PHYSX_DLL_SUFFIX}")
set_target_properties(ezPhysX::Cooking PROPERTIES IMPORTED_IMPLIB_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXCooking${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Cooking PROPERTIES IMPORTED_IMPLIB_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXCooking${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Cooking PROPERTIES IMPORTED_IMPLIB_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXCooking${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Cooking PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PHYSX_INC_DIR}")
target_link_libraries(ezPhysX::Cooking INTERFACE ezPhysX::Foundation)
ez_uwp_mark_import_as_content(ezPhysX::Cooking)

add_library(ezPhysX::Extensions STATIC IMPORTED GLOBAL)
set_target_properties(ezPhysX::Extensions PROPERTIES IMPORTED_LOCATION_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXExtensions_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Extensions PROPERTIES IMPORTED_LOCATION_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXExtensions_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Extensions PROPERTIES IMPORTED_LOCATION_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXExtensions_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Extensions PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PHYSX_INC_DIR}")
target_link_libraries(ezPhysX::Extensions INTERFACE ezPhysX::PhysX)

add_library(ezPhysX::Character STATIC IMPORTED GLOBAL)
set_target_properties(ezPhysX::Character PROPERTIES IMPORTED_LOCATION_DEBUG "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEBUG}/PhysXCharacterKinematic_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Character PROPERTIES IMPORTED_LOCATION_DEV "${PHYSX_BIN_DIR}/${PHYSX_BIN_DEV}/PhysXCharacterKinematic_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Character PROPERTIES IMPORTED_LOCATION_SHIPPING "${PHYSX_BIN_DIR}/${PHYSX_BIN_SHIPPING}/PhysXCharacterKinematic_static${PHYSX_LIB_SUFFIX}")
set_target_properties(ezPhysX::Character PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PHYSX_INC_DIR}")
target_link_libraries(ezPhysX::Character INTERFACE ezPhysX::PhysX)


