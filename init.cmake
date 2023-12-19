######################################
### PhysX support
######################################

if(EZ_CMAKE_PLATFORM_WINDOWS)
    set (EZ_BUILD_PHYSX OFF CACHE BOOL "Whether support for nVidia PhysX should be added")
else()
    set (EZ_BUILD_PHYSX OFF CACHE BOOL "Whether support for nVidia PhysX should be added" FORCE)
endif()

######################################
### ez_requires_physx()
######################################

macro(ez_requires_physx)

    ez_requires(EZ_CMAKE_PLATFORM_WINDOWS)
	ez_requires(EZ_BUILD_PHYSX)

endmacro()

######################################
### ez_link_target_physx(<target>)
######################################

function(ez_link_target_physx TARGET_NAME)

	ez_requires_physx()

    target_link_libraries(${TARGET_NAME} PRIVATE ezPhysX::PhysX)
    target_link_libraries(${TARGET_NAME} PRIVATE ezPhysX::Extensions)
    target_link_libraries(${TARGET_NAME} PRIVATE ezPhysX::PVD)
    target_link_libraries(${TARGET_NAME} PRIVATE ezPhysX::Character)

    ez_uwp_add_import_to_sources(${TARGET_NAME} ezPhysX::Foundation)
    ez_uwp_add_import_to_sources(${TARGET_NAME} ezPhysX::Common)
    ez_uwp_add_import_to_sources(${TARGET_NAME} ezPhysX::PhysX)

    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:ezPhysX::Foundation> $<TARGET_FILE_DIR:${TARGET_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:ezPhysX::Common> $<TARGET_FILE_DIR:${TARGET_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:ezPhysX::PhysX> $<TARGET_FILE_DIR:${TARGET_NAME}>
    )

endfunction()


######################################
### ez_link_target_physx_cooking(<target>)
######################################

function(ez_link_target_physx_cooking TARGET_NAME)

	ez_requires_physx()

    target_link_libraries(${TARGET_NAME} PRIVATE ezPhysX::Cooking)

    target_sources(${TARGET_NAME} PUBLIC $<TARGET_FILE:ezPhysX::Foundation>)
    target_sources(${TARGET_NAME} PUBLIC $<TARGET_FILE:ezPhysX::Cooking>)

    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:ezPhysX::Foundation> $<TARGET_FILE_DIR:${TARGET_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:ezPhysX::Cooking> $<TARGET_FILE_DIR:${TARGET_NAME}>
    )

endfunction()
