import QtQml.Models 2.2
import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0

PlasmaExtras.ScrollArea {
    id: scrollView

    property int itemheight
    property bool searchfieldhasactivefocus
    property bool searchfieldvisible

    function transfer_focus_from_searchfield_to_list() {
        if (bookmarklist.count == 0)
            bookmarklist.footerItem.focus = true;
        else
            bookmarklist.currentIndex = 0;
    }

    function hide_the_footer() {
        bookmarklist.footerItem.visible = false;
        bookmarklist.footerItem.height = 0;
        mainrepresentation.Layout.minimumHeight = (bookmarklist.count * (scrollView.itemheight) + bookmarklist.headerItem.height);
        mainrepresentation.Layout.maximumHeight = mainrepresentation.Layout.minimumHeight;
    }

    function show_the_footer() {
        bookmarklist.footerItem.height = scrollView.itemheight;
        mainrepresentation.Layout.minimumHeight = bookmarklist.headerItem.height + bookmarklist.footerItem.height;
        mainrepresentation.Layout.maximumHeight = mainrepresentation.Layout.minimumHeight;
    }

    visible: true
    focus: true
    anchors.fill: parent
    Layout.fillHeight: true

    Helper {
        id: helper
    }

    ListView {
        id: bookmarklist

        focus: true
        visible: true
        model: visualModel
        highlightFollowsCurrentItem: true
        highlightMoveVelocity: 800
        header: headerItem
        Keys.onPressed: {
            if (event.key === Qt.Key_Left) {
                visualModel.rootIndex = visualModel.parentModelIndex();
                event.accepted = true;
            }
            if (event.key === Qt.Key_Right || event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                if (!bookmarklist.currentItem.isAFolder)
                    helper.openURL(bookmarklist.currentItem.tooltip);
                else
                    visualModel.rootIndex = bookmarklist.model.modelIndex(bookmarklist.currentIndex);
                event.accepted = true;
            }
            if (event.key === Qt.Key_Up) {
                if (!(bookmarklist.currentIndex < bookmarklist.count) && !(bookmarklist.currentIndex > 0))
                    bookmarklist.currentIndex = bookmarklist.count - 1;

                bookmarklist.currentIndex = bookmarklist.currentIndex - 1 > 0 ? bookmarklist.currentIndex - 1 : 0;
                event.accepted = true;
            }
            if (event.key === Qt.Key_Down) {
                if (!(bookmarklist.currentIndex < bookmarklist.count) && !(bookmarklist.currentIndex > 0))
                    bookmarklist.currentIndex = 0;

                bookmarklist.currentIndex = bookmarklist.currentIndex + 1 < bookmarklist.count ? bookmarklist.currentIndex + 1 : bookmarklist.count;
                event.accepted = true;
            }
            if (event.key === Qt.Key_F) {
                if (event.modifiers === Qt.ControlModifier) {
                    if (bookmarklist.state === "default")
                        bookmarklist.state = "searchhasfocus";
                    else
                        bookmarklist.state = "default";
                }
            }
        }
        onCountChanged: {
            if (bookmarklist.footerItem) {
                if (bookmarklist.count == 0) {
                    bookmarklist.footerItem.visible = true;
                    if (bookmarklist.state != "searchhasfocus")
                        bookmarklist.footerItem.focus = true;

                    show_the_footer();
                } else {
                    hide_the_footer();
                }
            }
        }
        onVisibleChanged: {
            currentIndex = 0;
            if (visible) {
                //focus = true
                itemmodel.konquerorBookmarks = plasmoid.configuration.konquerorpath;
                itemmodel.okularBookmarks = plasmoid.configuration.okularpath;
                itemmodel.firefoxBookmarks = plasmoid.configuration.firefoxpath;
                itemmodel.chromeBookmarks = plasmoid.configuration.chromepath;
                //Don't force reread if paths are the same (false)
                itemmodel.ReadAllSources(false);
            }
        }
        Component.onCompleted: {
            bookmarklist.state = "default";
            itemmodel.ReadAllSources(true);
        }
        states: [
            State {
                name: "searchhasfocus"

                PropertyChanges {
                    target: scrollView
                    searchfieldhasactivefocus: true
                    searchfieldvisible: true
                }

                PropertyChanges {
                    target: bookmarklist
                    currentIndex: -1
                }

            },
            State {
                name: "default"

                PropertyChanges {
                    target: scrollView
                    searchfieldhasactivefocus: false
                    searchfieldvisible: false
                }

            }
        ]

        DelegateModel {
            id: visualModel

            model: itemmodel

            delegate: Bookmarkdelegate {
                bookmarktext: display
                itemheight: scrollView.itemheight
                iconSource: icon
                tooltip: ttp
                isAFolder: isFolder
            }

        }

        Component {
            id: headerItem

            RowLayout {
                id: head

                height: itemheight
                width: bookmarklist.width

                PlasmaComponents.ToolButton {
                    id: buttonorganize

                    iconName: "bookmarks-organize.png"
                    text: i18n("Edit")
                    tooltip: i18n("Organize KDE Bookmarks")
                    width: 30
                    Layout.fillHeight: true
                    onClicked: {
                        executable.exec("keditbookmarks " + itemmodel.konquerorBookmarks);
                    }
                }

                PlasmaComponents.TextField {
                    id: searchfield

                    visible: scrollView.searchfieldvisible
                    focus: scrollView.searchfieldhasactivefocus
                    clearButtonShown: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onTextChanged: {
                        itemmodel.setSearchField(text);
                    }
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Down || event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                            transfer_focus_from_searchfield_to_list();
                            event.accepted = true;
                        }
                    }
                }

                PlasmaComponents.ToolButton {
                    id: buttonrefresh

                    width: 30
                    iconName: "view-refresh"
                    text: i18n("Refresh")
                    tooltip: i18n("Re-read sources")
                    Layout.fillHeight: true
                    onClicked: {
                        itemmodel.ReadAllSources(true);
                    }
                }

            }

        }

        highlight: PlasmaComponents.Highlight {
            y: 0
        }

        footer: PlasmaComponents.ToolButton {
            width: bookmarklist.width
            height: itemheight
            iconSource: "go-previous-view"
            text: "Go back"
            visible: false
            onClicked: {
                visualModel.rootIndex = visualModel.parentModelIndex();
            }
        }

    }

}
