#ifndef BOOKMARKSMODULE_TEST_HPP
#define BOOKMARKSMODULE_TEST_HPP
#include <QtTest/QTest>
#include <QtCore/QSharedPointer>
#include <bookmarkmodel.hpp>
class bookmarksmodule_test: public QObject 
{
    Q_OBJECT
public:
    bookmarksmodule_test();
private Q_SLOTS:
    // will be called before the first testfunction is executed.
    void initTestCase();
    // will be called after the last testfunction was executed.
    void cleanupTestCase();
    // will be called before each testfunction is executed.
    void init();
    // will be called after every testfunction.
    void cleanup();
    
    void path_are_set_correctly();
    
    void get_correct_number_of_element_for_konqueror_bookmarks();
    void get_correct_number_of_element_for_okular_bookmarks();
private:
    QSharedPointer<Bookmarkmodel> m_model{};
};

#endif // BOOKMARKSMODULE_TEST_HPP
