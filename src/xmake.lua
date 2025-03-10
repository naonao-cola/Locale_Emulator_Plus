add_includedirs(os.scriptdir())
add_defines("WIN32_LEAN_AND_MEAN")

add_packages("microsoft-detours", "cpp-ipc")

target("locale_emulator_plus")
    set_kind("shared")
    -- https://github.com/microsoft/Detours/wiki/DetourFinishHelperProcess
    add_files("core/export.def")
    add_files(
        "core/*.cpp",
        "core/hook/common.cpp",
        "core/hook/table.cpp"
    )

    add_headerfiles("core/**.hpp")
    add_cxxflags("/wd4003", "/kernel", {tools = "cl"})

    if is_plat("mingw") then
        -- libxxx -> xxx
        set_prefixname("")
        add_cxxflags("-fpermissive")
    end

    add_syslinks("user32")

    on_load(function (target)
        local arch
        if target:is_arch("x86", "i386") then
            arch = "32"
        elseif target:is_arch("x64", "x86_64") then
            arch = "64"
        end

        target:set("basename", target:name() .. arch)
    end)

target("locale_emulator_plus_tool")
    set_default(false)
    set_kind("binary")
    add_files("tool/*.cpp")
    add_syslinks("shlwapi")

    add_deps("locale_emulator_plus", {inherit = false})
