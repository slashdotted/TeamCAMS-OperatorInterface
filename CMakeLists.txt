cmake_minimum_required(VERSION 3.16)

project(
  TeamCAMSOperatorInterface
  VERSION 2026.9
  LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.6 REQUIRED COMPONENTS Quick WebSockets)

qt_standard_project_setup()

set(QT_QML_GENERATE_QMLLS_INI ON)

set(NETWORK_CORE_SOURCES src/network/messagetransport.h
                         src/network/messagetransport.cpp)

set(MONOCYPHER_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libs/monocypher-4.0.3/src/monocypher.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libs/monocypher-4.0.3/src/monocypher.c)

set(MQTTPROXY_SOURCES
    src/network/mqtt/mqtttransport.h
    src/network/mqtt/mqtttransport.cpp
    src/network/mqtt/mqtttopic.h
    src/network/mqtt/mqtttopic.cpp
    src/network/mqtt/mqttexperimentclient.h
    src/network/mqtt/mqttexperimentclient.cpp
    src/network/mqtt/mqttcrypto.h
    src/network/mqtt/mqttcrypto.cpp)

qt_add_executable(TeamCAMSOperatorInterface main.cpp ${NETWORK_CORE_SOURCES}
                  ${MQTTPROXY_SOURCES} ${MONOCYPHER_SOURCES})

set(MONOCYPHER_INCLUDE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/src/libs/monocypher-4.0.3/src")

target_include_directories(
  TeamCAMSOperatorInterface PRIVATE ${MONOCYPHER_INCLUDE_DIR}
                                    "${CMAKE_CURRENT_SOURCE_DIR}/src")

target_compile_definitions(
  TeamCAMSOperatorInterface PRIVATE $<$<CONFIG:Release>:QT_NO_DEBUG_OUTPUT>
                                    $<$<CONFIG:MinSizeRel>:QT_NO_DEBUG_OUTPUT>)

qt_add_resources(
  TeamCAMSOperatorInterface
  "sounds"
  PREFIX
  "/"
  BIG_RESOURCES
  FILES
  qml/assets/sounds/alarm.mp3
  qml/assets/sounds/bip.mp3
  qml/assets/sounds/chime.mp3
  qml/assets/sounds/click.mp3
  qml/assets/sounds/highchime.mp3
  qml/assets/sounds/press.mp3
  qml/assets/sounds/release.mp3
  qml/assets/sounds/tack.mp3
  qml/assets/sounds/tone.mp3)

qt_add_resources(
  TeamCAMSOperatorInterface
  "images"
  PREFIX
  "/"
  BIG_RESOURCES
  FILES
  qml/assets/images/alt_lcd_0.svg
  qml/assets/images/alt_lcd_1.svg
  qml/assets/images/alt_lcd_2.svg
  qml/assets/images/alt_lcd_3.svg
  qml/assets/images/alt_lcd_4.svg
  qml/assets/images/alt_lcd_5.svg
  qml/assets/images/alt_lcd_6.svg
  qml/assets/images/alt_lcd_7.svg
  qml/assets/images/alt_lcd_8.svg
  qml/assets/images/alt_lcd_9.svg
  qml/assets/images/alt_lcd_off.svg
  qml/assets/images/alt_lcd_-.svg
  qml/assets/images/button_frame.png
  qml/assets/images/button_slider.png
  qml/assets/images/buttons.svg
  qml/assets/images/chatbox.svg
  qml/assets/images/cooler.svg
  qml/assets/images/dehumidifier.svg
  qml/assets/images/heater.svg
  qml/assets/images/icon.png
  qml/assets/images/lamp_blue_off.png
  qml/assets/images/lamp_blue_on.png
  qml/assets/images/lamp_green_off.png
  qml/assets/images/lamp_green_on.png
  qml/assets/images/lamp_red_off.png
  qml/assets/images/lamp_red_on.png
  qml/assets/images/lamp_yellow_off.png
  qml/assets/images/lamp_yellow_on.png
  qml/assets/images/lcd_0.svg
  qml/assets/images/lcd_1.svg
  qml/assets/images/lcd_2.svg
  qml/assets/images/lcd_3.svg
  qml/assets/images/lcd_4.svg
  qml/assets/images/lcd_5.svg
  qml/assets/images/lcd_6.svg
  qml/assets/images/lcd_7.svg
  qml/assets/images/lcd_8.svg
  qml/assets/images/lcd_9.svg
  qml/assets/images/lcd_off.svg
  qml/assets/images/lcd.svg
  qml/assets/images/lcd_-.svg
  qml/assets/images/metal-texture.jpg
  qml/assets/images/minus.svg
  qml/assets/images/mixer.svg
  qml/assets/images/plus.svg
  qml/assets/images/refresh.svg
  qml/assets/images/repair.svg
  qml/assets/images/scrubber.svg
  qml/assets/images/simboli.svg
  qml/assets/images/sysoverview.svg
  qml/assets/images/temperature.svg
  qml/assets/images/Texture.png
  qml/assets/images/transmission.svg
  qml/assets/images/valve.svg
  qml/assets/images/vent.svg)

qt_add_resources(TeamCAMSOperatorInterface "js" PREFIX "/" FILES
                 qml/js/Utils.js)

set_source_files_properties(qml/EventBus.qml PROPERTIES QT_QML_SINGLETON_TYPE
                                                        TRUE)
set_source_files_properties(qml/Registry.qml PROPERTIES QT_QML_SINGLETON_TYPE
                                                        TRUE)
set_source_files_properties(qml/SettingsManager.qml
                            PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(qml/Communication.qml
                            PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(qml/Inbox.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(qml/SoundEffectProxy.qml
                            PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(
  TeamCAMSOperatorInterface
  URI
  TeamCAMSOperatorInterface
  VERSION
  1.0
  QML_FILES
  qml/Main.qml
  qml/SoundEffectProxy.qml
  qml/Inbox.qml
  qml/Communication.qml
  qml/EventBus.qml
  qml/SettingsManager.qml
  qml/widgets/BaseControl.qml
  qml/widgets/BaseControlExt.qml
  qml/widgets/FourSlideSwitch.qml
  qml/widgets/SimpleImageButton.qml
  qml/widgets/Lamp.qml
  qml/widgets/LCDDisplay.qml
  qml/widgets/LevelSwitch.qml
  qml/widgets/LikertBox.qml
  qml/widgets/LineGraph.qml
  qml/widgets/LOAInterface.qml
  qml/widgets/LOASelector.qml
  qml/widgets/LOASimpleSuggestionBox.qml
  qml/widgets/LOASuggestionBox.qml
  qml/widgets/RepairOverview.qml
  qml/widgets/SimpleButton.qml
  qml/widgets/SimpleTextInput.qml
  qml/widgets/ThreeSlideSwitch.qml
  qml/widgets/TouchInputDisplay.qml
  qml/widgets/MessagingBox.qml
  qml/widgets/TwoSlideSwitch.qml
  qml/widgets/OwnMessageBubble.qml
  qml/widgets/OtherMessageBubble.qml
  qml/widgets/RepairBox.qml
  qml/widgets/SurveyBox.qml
  qml/views/CommandPanel.qml
  qml/views/Contents.qml
  qml/views/LinePlot.qml
  qml/views/LOAFrame.qml
  qml/views/LOAPanel.qml
  qml/views/N2LoggingTaskPanel.qml
  qml/views/RepairTaskPanel.qml
  qml/views/SystemOverview.qml
  qml/views/TransmissionTaskPanel.qml
  qml/views/LOAPanelExt.qml
  qml/views/CommandPanelExt.qml
  qml/views/DisabledUI.qml
  qml/views/GenericLayout.qml
  qml/utils/TimedParentVisibility.qml
  qml/utils/DialogProxy.qml
  qml/utils/SystemTimer.qml
  qml/utils/PlotBuffer.qml
  qml/dialogs/ConnectionDialog.qml
  qml/dialogs/MessagingDialog.qml
  qml/dialogs/RepairDialog.qml
  qml/dialogs/SurveyDialog.qml
  qml/dialogs/LOAChangeNotificationDialog.qml
  SOURCES
  src/toolbox.cpp
  src/toolbox.h
  src/mqttproxy.h
  src/mqttproxy.cpp)

set_target_properties(
  TeamCAMSOperatorInterface
  PROPERTIES QT_WASM_HTML_TEMPLATE
             "${CMAKE_CURRENT_SOURCE_DIR}/templates/index.html")

file(
  COPY "${CMAKE_CURRENT_SOURCE_DIR}/qml/assets/sounds/"
  DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/sounds"
  FILES_MATCHING
  PATTERN "*.wav"
  PATTERN "*.mp3"
  PATTERN "*.ogg")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/templates/favicon.ico
               ${CMAKE_CURRENT_BINARY_DIR}/favicon.ico COPYONLY)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/templates/index.html
               ${CMAKE_CURRENT_BINARY_DIR}/index.html COPYONLY)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/templates/proxy.php
               ${CMAKE_CURRENT_BINARY_DIR}/proxy.php COPYONLY)

file(
  COPY "${CMAKE_CURRENT_SOURCE_DIR}/templates/pdfjs-6.2.108-dist/"
  DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/pdfjs"
  FILES_MATCHING
  PATTERN "*.*")

set_target_properties(
  TeamCAMSOperatorInterface
  PROPERTIES MACOSX_BUNDLE_GUI_IDENTIFIER ch.unifr.teamcams.client
             MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
             MACOSX_BUNDLE_SHORT_VERSION_STRING
             ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
             MACOSX_BUNDLE TRUE
             WIN32_EXECUTABLE TRUE)

target_link_libraries(TeamCAMSOperatorInterface PRIVATE Qt6::Quick
                                                        Qt6::WebSockets)

install(
  TARGETS TeamCAMSOperatorInterface
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
