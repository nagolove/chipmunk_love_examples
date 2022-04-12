workspace "wrapper"
    configurations { "Debug", "Release" }

    project "wrp"
        kind "SharedLib"
        language "C"
        
        --targetdir "bin/%{cfg.buildcfg}"
        --targetdir "bin/%{cfg.buildcfg}"
        
        targetprefix ""
        targetdir "."

        files { "**.h", "**.c" }
        includedirs { 
            "/usr/include/luajit-2.1",
            "/home/nagolove/myprojects/lua_capi",
            "/home/nagolove/projects/Chipmunk2D/include",
        }
        buildoptions { 
            "-fPIC",
            "-Wall",
            "-Werror",
            "-Wno-strict-aliasing",
        }
        links { 
            "luajit-5.1", 
            "chipmunk",
            "lua_tools",
        }
        libdirs { 
            "/home/nagolove/projects/Chipmunk2D/src/",
            "/home/nagolove/myprojects/c_guard",
            "/home/nagolove/myprojects/lua_capi",
        }

    filter "configurations:Debug"
    defines { "DEBUG" }
    symbols "On"

    filter "configurations:Release"
    defines { "NDEBUG" }
    optimize "On"
