cmake_minimum_required(VERSION 3.16)

project(TeslaInfotainment VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appTeslaInfotainment
    main.cpp
    Controllers/system.cpp
    Controllers/system.h
)

qt_add_qml_module(appTeslaInfotainment
    URI TeslaInfotainment
    VERSION 1.0
    QML_FILES Main.qml
    	ui/BottomBar/BottomBar.qml
        ui/RightScreen/RightScreen.qml
        ui/LeftScreen/LeftScreen.qml
        ui/assets/car_render.png
        ui/assets/tesla_car_icon.png
        ui/assets/lock.png
        ui/assets/unlock.png
        ui/assets/user-icon.png
)

set_target_properties(appTeslaInfotainment PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTeslaInfotainment
    PRIVATE Qt6::Quick
)

install(TARGETS appTeslaInfotainment
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
