import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Window {
    id: root
    visible: true
    width: 800
    height: 650
    title: "Chess Game"

    // Главное меню
    MainMenu {
        id: mainMenu
        width: parent.width
        height: parent.height
    }

    // Окно настроек (изначально скрыто)
    SettingsWindow {
        id: settingsWindow
        visible: false
        width: parent.width
        height: parent.height
    }
}
/*
Window {
    id: root
    width: 800
    height: 650
    visible: true
    title: "Шахматы"

    property int boardMargin: 20
    property int boardSize: Math.min(width, height - 50) - (2 * boardMargin)
    property int cellSize: boardSize / 8
    property var selectedPiece: null
    property bool inMenu: true

    // Функция для преобразования логических координат в визуальные
    function logicalToVisualPos(x, y) {
        return {
            x: x * cellSize,
            y: (7 - y) * cellSize
        }
    }

    // Функция для преобразования визуальных координат в логические
    function visualToLogicalPos(x, y) {
        return {
            x: Math.floor(x / cellSize),
            y: 7 - Math.floor(y / cellSize)
        }
    }

    // Очистка всех индикаторов и выбранных фигур
    function clearAllSelections() {
        moveIndicators.visible = false
        if (selectedPiece !== null) {
            selectedPiece.highlighted = false
        }
        selectedPiece = null
    }

    // Начальный экран с выбором режима игры
    Rectangle {
        id: menuScreen
        anchors.fill: parent
        visible: inMenu

        // Добавляем изображение как фон
        Image {
            anchors.fill: parent
            source: "../resources/images/fon.png"  // Убедитесь, что путь к изображению правильный
            fillMode: Image.PreserveAspectCrop       // Сохраняет пропорции изображения и обрезает лишнее
        }

        Rectangle {

            width: 400
            height: 520
            color: "white"
            radius: 10
            border.color: "#CCCCCC"
            border.width: 1
            anchors.centerIn: parent

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 25
                width: parent.width - 40

                Text {
                    text: "Шахматы"
                    font.pixelSize: 32
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Выберите режим игры"
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                }

                Button {
                    text: "Игра на двоих"
                    Layout.preferredHeight: 60
                    Layout.fillWidth: true
                    font.pixelSize: 16

                    onClicked: {
                        chessEngine.setGameMode("twoPlayers")
                        chessEngine.startNewGame()
                        inMenu = false
                    }
                }

                // Секция настроек игры против компьютера
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    color: "#F8F8F8"
                    radius: 10
                    border.color: "#E0E0E0"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Text {
                            text: "Игра против компьютера"
                            font.pixelSize: 18
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Выберите уровень сложности:"
                            font.pixelSize: 14
                            Layout.topMargin: 5
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Кнопки выбора сложности
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            // Легкий
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 80
                                radius: 8
                                color: chessEngine.difficulty === 1 ? "#D4EDDA" : "#F8F9FA"
                                border.color: chessEngine.difficulty === 1 ? "#28A745" : "#DEE2E6"
                                border.width: 2

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 5

                                    Text {
                                        text: "🙂"
                                        font.pixelSize: 24
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        text: "Легкий"
                                        font.pixelSize: 14
                                        font.bold: chessEngine.difficulty === 1
                                        color: chessEngine.difficulty === 1 ? "#155724" : "#212529"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: chessEngine.difficulty = 1
                                }
                            }

                            // Средний
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 80
                                radius: 8
                                color: chessEngine.difficulty === 2 ? "#CCE5FF" : "#F8F9FA"
                                border.color: chessEngine.difficulty === 2 ? "#0D6EFD" : "#DEE2E6"
                                border.width: 2

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 5

                                    Text {
                                        text: "😐"
                                        font.pixelSize: 24
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        text: "Средний"
                                        font.pixelSize: 14
                                        font.bold: chessEngine.difficulty === 2
                                        color: chessEngine.difficulty === 2 ? "#084298" : "#212529"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: chessEngine.difficulty = 2
                                }
                            }

                            // Сложный
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 80
                                radius: 8
                                color: chessEngine.difficulty === 3 ? "#F8D7DA" : "#F8F9FA"
                                border.color: chessEngine.difficulty === 3 ? "#DC3545" : "#DEE2E6"
                                border.width: 2

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 5

                                    Text {
                                        text: "😈"
                                        font.pixelSize: 24
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Text {
                                        text: "Сложный"
                                        font.pixelSize: 14
                                        font.bold: chessEngine.difficulty === 3
                                        color: chessEngine.difficulty === 3 ? "#842029" : "#212529"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: chessEngine.difficulty = 3
                                }
                            }
                        }

                        Button {
                            text: "Начать игру"
                            Layout.preferredHeight: 40
                            Layout.fillWidth: true
                            font.pixelSize: 15
                            highlighted: true

                            onClicked: {
                                chessEngine.setGameMode("vsComputer")
                                chessEngine.startNewGame()
                                inMenu = false
                            }
                        }
                    }
                }

                Button {
                    text: "Загрузить сохраненную партию"
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    font.pixelSize: 16
                    enabled: chessEngine.getSavedGames().length > 0

                    onClicked: {
                        loadGameDialog.open();
                    }
                }
            }
        }
    }

    // Игровой экран
    Item {
        anchors.fill: parent
        visible: !inMenu

        // Упрощенный компонент шахматной фигуры без перетаскивания
        component ChessPiece: Image {
            id: piece

            property int pieceX: 0  // Логическая X координата (0-7)
            property int pieceY: 0  // Логическая Y координата (0-7)
            property bool highlighted: false

            // Небольшой эффект подсветки для выбранной фигуры
            Rectangle {
                anchors.fill: parent
                color: "yellow"
                opacity: piece.highlighted ? 0.3 : 0
                z: -1
            }

            // Начальное позиционирование
            Component.onCompleted: {
                let pos = logicalToVisualPos(pieceX, pieceY)
                x = pos.x
                y = pos.y
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    // Уже выбрана эта фигура - отменяем выбор
                    if (selectedPiece === piece) {
                        clearAllSelections()
                        return
                    }

                    // Сбрасываем предыдущие выборы
                    clearAllSelections()

                    // Проверяем, может ли эта фигура ходить
                    let legalMoves = chessEngine.getLegalMovesForPiece(pieceX, pieceY)

                    if (legalMoves.length > 0) {
                        // Показываем возможные ходы
                        moveIndicators.fromX = pieceX
                        moveIndicators.fromY = pieceY
                        moveIndicators.legalMoves = legalMoves
                        moveIndicators.visible = true

                        // Выделяем выбранную фигуру
                        piece.highlighted = true
                        selectedPiece = piece
                    }
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Text {
                    id: statusText
                    text: chessEngine.status
                    font.pixelSize: 18
                }

                Button {
                    text: "В меню"
                    onClicked: {
                        inMenu = true
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    id: board
                    anchors.centerIn: parent
                    width: boardSize
                    height: boardSize
                    color: "#FFFFFF"

                    // MouseArea для фона доски чтобы снимать выделения по клику на пустую область
                    MouseArea {
                        anchors.fill: parent
                        z: -1  // Под всеми фигурами
                        onClicked: {
                            clearAllSelections()
                        }
                    }

                    // Рисуем шахматную доску
                    Grid {
                        anchors.fill: parent
                        rows: 8
                        columns: 8

                        Repeater {
                            model: 64

                            Rectangle {
                                width: cellSize
                                height: cellSize
                                color: {
                                    let row = Math.floor(index / 8)
                                    let col = index % 8
                                    return (row + col) % 2 === 0 ? "#F1D9B5" : "#B98863"
                                }
                            }
                        }
                    }

                    // Компонент для выделения последнего хода
                    Item {
                        id: lastMoveHighlight
                        anchors.fill: parent
                        visible: chessEngine.hasLastMove()
                        z: 1  // Над доской

                        Rectangle {
                            width: cellSize
                            height: cellSize
                            x: chessEngine.hasLastMove() ? chessEngine.getLastMoveFrom().x * cellSize : 0
                            y: chessEngine.hasLastMove() ? (7 - chessEngine.getLastMoveFrom().y) * cellSize : 0
                            color: "#FFFF0055" // Полупрозрачный желтый
                            visible: chessEngine.hasLastMove()
                        }

                        Rectangle {
                            width: cellSize
                            height: cellSize
                            x: chessEngine.hasLastMove() ? chessEngine.getLastMoveTo().x * cellSize : 0
                            y: chessEngine.hasLastMove() ? (7 - chessEngine.getLastMoveTo().y) * cellSize : 0
                            color: "#FFFF0055" // Полупрозрачный желтый
                            visible: chessEngine.hasLastMove()
                        }
                    }

                    // Шахматные фигуры
                    Repeater {
                        id: piecesRepeater
                        model: chessEngine.getPieces()

                        ChessPiece {
                            width: cellSize
                            height: cellSize
                            source: resourceManager.getTexturePath(modelData.type)
                            pieceX: modelData.x
                            pieceY: modelData.y
                        }
                    }

                    // Индикаторы возможных ходов
                    Item {
                        id: moveIndicators
                        anchors.fill: parent
                        visible: false

                        property var legalMoves: []
                        property int fromX: -1
                        property int fromY: -1

                        Repeater {
                            id: movesRepeater
                            model: moveIndicators.legalMoves

                            Rectangle {
                                property var visualPos: logicalToVisualPos(modelData.x, modelData.y)

                                x: visualPos.x
                                y: visualPos.y
                                width: cellSize
                                height: cellSize
                                color: "transparent"
                                border.width: 3
                                border.color: "#32CD32"
                                radius: cellSize / 2
                                opacity: 0.7

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (chessEngine.processMove(
                                            moveIndicators.fromX, moveIndicators.fromY,
                                            modelData.x, modelData.y)) {
                                            clearAllSelections()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Кнопка новой игры
                    Button {
                        id: newGameButton
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: -35
                        }
                        text: "Новая игра"
                        onClicked: {
                            chessEngine.startNewGame()
                            clearAllSelections()
                        }
                    }
                }
            }

            // Панель с кнопками управления
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Button {
                    id: saveButton
                    text: "Сохранить партию"
                    enabled: chessEngine.getSavedGames().length < 3

                    onClicked: {
                        gameNameInput.text = "";
                        saveGameDialog.open();
                    }
                }

                Button {
                    id: loadButton
                    text: "Загрузить партию"
                    enabled: chessEngine.getSavedGames().length > 0

                    onClicked: {
                        loadGameDialog.open();
                    }
                }

                Button {
                    id: undoButton
                    text: "Отменить ход"
                    enabled: chessEngine.canUndo()

                    onClicked: {
                        chessEngine.undoLastMove();
                    }
                }
            }
        }
    }

    // Обработка сигналов от движка
    Connections {
        target: chessEngine

        function onGameEnded(result) {
            resultDialog.text = result
            resultDialog.open()
        }

        function onPiecesChanged() {
            // Сбрасываем все выбранные фигуры и индикаторы при обновлении доски
            clearAllSelections()
            piecesRepeater.model = chessEngine.getPieces()
        }

        function onStatusChanged() {
            // Дополнительно убеждаемся, что индикаторы очищаются при смене хода
            clearAllSelections()
        }

        function onPawnPromotion(fromX, fromY, toX, toY) {
            promotionDialog.fromX = fromX
            promotionDialog.fromY = fromY
            promotionDialog.toX = toX
            promotionDialog.toY = toY
            promotionDialog.open()
        }

        function onLastMoveChanged() {
            console.log("Last move changed, has move: " + chessEngine.hasLastMove());
            if (chessEngine.hasLastMove()) {
                console.log("From: " + chessEngine.getLastMoveFrom().x + "," + chessEngine.getLastMoveFrom().y);
                console.log("To: " + chessEngine.getLastMoveTo().x + "," + chessEngine.getLastMoveTo().y);
            }
            lastMoveHighlight.visible = chessEngine.hasLastMove()
        }

        // Добавляем обработку изменения уровня сложности
        function onDifficultyChanged() {
            // Этот метод будет вызываться при изменении сложности
            // Интерфейс будет автоматически обновляться благодаря привязкам
        }

        // Добавляем обработку изменения списка сохраненных партий
        function onSavedGamesChanged() {
            // Обновляем состояние кнопок
            saveButton.enabled = chessEngine.getSavedGames().length < 3
            loadButton.enabled = chessEngine.getSavedGames().length > 0
        }
    }

    Dialog {
        id: resultDialog
        title: "Игра окончена"
        property string text: ""

        Label {
            text: resultDialog.text
            font.pixelSize: 16
        }

        standardButtons: Dialog.Ok

        anchors.centerIn: Overlay.overlay

        onAccepted: {
            close()
        }
    }

    // Диалог выбора фигуры для превращения пешки
    Dialog {
        id: promotionDialog
        title: "Превращение пешки"
        modal: true
        closePolicy: Dialog.NoAutoClose

        property int fromX: -1
        property int fromY: -1
        property int toX: -1
        property int toY: -1

        anchors.centerIn: Overlay.overlay

        ColumnLayout {
            width: 300
            spacing: 10

            Text {
                text: "Выберите фигуру для превращения пешки:"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Repeater {
                    model: ["queen", "rook", "bishop", "knight"]

                    delegate: Rectangle {
                        width: 60
                        height: 60
                        color: "#F0F0F0"
                        border.color: "#CCCCCC"
                        border.width: 1

                        Image {
                            anchors.fill: parent
                            anchors.margins: 5
                            source: {
                                // Определяем сторону (белые или черные) на основе положения
                                let side = promotionDialog.toY === 7 ? "white" : "black";
                                return resourceManager.getTexturePath(side + modelData.charAt(0).toUpperCase() + modelData.slice(1));
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                let pieceType = modelData;
                                chessEngine.promotePawn(
                                    promotionDialog.fromX,
                                    promotionDialog.fromY,
                                    promotionDialog.toX,
                                    promotionDialog.toY,
                                    pieceType
                                );
                                promotionDialog.close();
                            }
                        }
                    }
                }
            }
        }
    }

    // Диалог сохранения партии
    Dialog {
        id: saveGameDialog
        title: "Сохранение партии"
        modal: true
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Save | Dialog.Cancel

        property bool canSave: gameNameInput.text.trim().length > 0

        onAccepted: {
            if (canSave) {
                chessEngine.saveGame(gameNameInput.text.trim());
            }
        }

        ColumnLayout {
            width: 300
            spacing: 10

            Text {
                text: "Введите название сохранения:"
                font.pixelSize: 14
            }

            TextField {
                id: gameNameInput
                Layout.fillWidth: true
                placeholderText: "Название партии"
                selectByMouse: true
                onTextChanged: {
                    saveGameDialog.canSave = text.trim().length > 0
                }
            }

            Text {
                text: "Максимум 3 сохранения. Новое сохранение будет добавлено, если у вас меньше 3-х сохранений."
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                color: "#666"
            }
        }
    }

    // Диалог загрузки партии
    Dialog {
        id: loadGameDialog
        title: "Загрузка сохраненной партии"
        modal: true
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Close
        width: 450

        ColumnLayout {
            width: 400
            spacing: 15

            Text {
                text: "Выберите сохранение для загрузки:"
                font.pixelSize: 14
            }

            ListView {
                id: savedGamesList
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                clip: true
                model: chessEngine.getSavedGames()
                delegate: Rectangle {
                    width: savedGamesList.width
                    height: 80
                    color: index % 2 === 0 ? "#f5f5f5" : "#ffffff"
                    border.color: "#e0e0e0"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        // Информация о сохранении
                        Column {
                            Layout.fillWidth: true
                            spacing: 4

                            Text {
                                text: modelData.name
                                font.bold: true
                                font.pixelSize: 14
                            }

                            Text {
                                text: "Дата: " + modelData.date
                                font.pixelSize: 12
                                color: "#666"
                            }

                            Text {
                                text: "Режим: " + (modelData.gameMode === "twoPlayers" ? "Игра на двоих" : "Против компьютера") +
                                      (modelData.gameMode === "vsComputer" ? " (Сложность: " +
                                      (modelData.difficulty === 1 ? "Легкий" :
                                       modelData.difficulty === 2 ? "Средний" : "Сложный") + ")" : "")
                                font.pixelSize: 12
                                color: "#666"
                            }

                            Text {
                                text: "Статус: " + modelData.status
                                font.pixelSize: 12
                                color: "#666"
                            }
                        }

                        // Кнопки действий
                        Column {
                            spacing: 6

                            Button {
                                text: "Загрузить"
                                width: 100
                                onClicked: {
                                    chessEngine.loadGame(modelData.slot);
                                    loadGameDialog.close();
                                    inMenu = false; // Переходим к игре
                                }
                            }

                            Button {
                                text: "Удалить"
                                width: 100
                                onClicked: {
                                    deleteConfirmDialog.slotToDelete = modelData.slot;
                                    deleteConfirmDialog.gameName = modelData.name;
                                    deleteConfirmDialog.open();
                                }
                            }
                        }
                    }
                }
            }

            Text {
                text: savedGamesList.model.length === 0 ? "У вас пока нет сохраненных партий." : ""
                font.pixelSize: 14
                color: "#666"
                Layout.alignment: Qt.AlignHCenter
                visible: savedGamesList.model.length === 0
            }
        }

        Connections {
            target: chessEngine
            function onSavedGamesChanged() {
                savedGamesList.model = chessEngine.getSavedGames();
            }
        }
    }

    // Диалог подтверждения удаления
    Dialog {
        id: deleteConfirmDialog
        title: "Удаление сохранения"
        modal: true
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Yes | Dialog.No

        property int slotToDelete: -1
        property string gameName: ""

        onAccepted: {
            if (slotToDelete >= 0) {
                chessEngine.deleteGame(slotToDelete);
            }
        }

        Text {
            text: "Вы действительно хотите удалить сохранение \"" + deleteConfirmDialog.gameName + "\"?"
            font.pixelSize: 14
            wrapMode: Text.WordWrap
            width: 300
        }
    }
}
*/
