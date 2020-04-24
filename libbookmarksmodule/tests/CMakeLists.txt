SET (bookmarkmodelTEST)
ENABLE_TESTING (true)

FIND_PACKAGE (Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Core Widgets Qml
                                                               Test)

FIND_PACKAGE (KF5IconThemes)

SET (TESTSRC bookmarksmoduletest.cpp)
SET (TESTEXE bookmarkmodeltest)
SET (TESTRC resources/Bookmarks resources/konqueror_bookmarks.xml
            resources/okular_bookmarks.xml)

FOREACH (_file ${TESTRC})
  FILE (COPY ${_file} DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
ENDFOREACH ()

ADD_EXECUTABLE (${TESTEXE} ${TESTSRC})
ADD_TEST (bookmarkmodeltest ${TESTEXE})

TARGET_LINK_LIBRARIES (${TESTEXE} PRIVATE ${LIBNAME} Qt5::Test)