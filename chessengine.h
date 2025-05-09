#pragma once

#include <QObject>
#include <QString>
#include <QVariant>
#include <QVector>
#include <QMap>
#include <QPoint>
#include <QTimer>
#include <QStack>
#include <chrono>
#include <QSettings>
#include <QDateTime>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "Position.h"
#include "AI.h"

#define nsecs std::chrono::high_resolution_clock::now().time_since_epoch().count()

class ChessEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(int difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(bool canUndo READ canUndo NOTIFY canUndoChanged)

public:
    explicit ChessEngine(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getPieces() const;
    Q_INVOKABLE bool processMove(int fromX, int fromY, int toX, int toY);
    Q_INVOKABLE QVariantList getLegalMovesForPiece(int x, int y) const;
    Q_INVOKABLE void startNewGame();
    Q_INVOKABLE void setGameMode(const QString& mode);
    Q_INVOKABLE QString getTextureName(int x, int y) const;
    Q_INVOKABLE void makeAIMove();
    Q_INVOKABLE bool promotePawn(int fromX, int fromY, int toX, int toY, const QString& pieceType);

    // Методы для отмены хода
    Q_INVOKABLE bool undoLastMove();
    bool canUndo() const;

    // Методы для выделения хода компьютера
    Q_INVOKABLE QPoint getLastMoveFrom() const;
    Q_INVOKABLE QPoint getLastMoveTo() const;
    Q_INVOKABLE bool hasLastMove() const;

    // Методы для сохранения/загрузки партий
    Q_INVOKABLE bool saveGame(const QString& name);
    Q_INVOKABLE bool loadGame(int slot);
    Q_INVOKABLE QVariantList getSavedGames() const;
    Q_INVOKABLE bool deleteGame(int slot);

    // Методы для работы со сложностью
    int difficulty() const;
    void setDifficulty(int newDifficulty);
    Q_INVOKABLE QString getDifficultyName() const;

    QString status() const;

signals:
    void piecesChanged();
    void statusChanged();
    void gameEnded(const QString& result);
    void pawnPromotion(int fromX, int fromY, int toX, int toY);
    void difficultyChanged();
    void canUndoChanged();
    void lastMoveChanged();
    void savedGamesChanged();

private:
    enum STATUS {
        WHITE_TO_MOVE,
        BLACK_TO_MOVE,
        WHITE_WON,
        BLACK_WON,
        DRAW
    };

    enum class GameMode {
        TwoPlayers,
        VsComputer
    };

    struct MoveHistoryItem {
        Position position;
        QPoint moveFrom;
        QPoint moveTo;
    };

    struct SavedGame {
        QString name;
        QString date;
        QString gameMode;
        int difficulty;
        QString status;
        QString fen;
        QVector<QPoint> moveFromHistory;
        QVector<QPoint> moveToHistory;
    };

    Position position;
    QPoint selectedPiece;
    STATUS currentStatus;
    GameMode gameMode;
    int m_difficulty; // 1 - легкий, 2 - средний, 3 - сложный

    QStack<MoveHistoryItem> moveHistory;
    QPoint lastMoveFrom;
    QPoint lastMoveTo;
    bool hasLastMoveInfo;

    QVector<SavedGame> savedGames;

    void updateStatus();
    QString statusToString() const;
    uint8_t getStatus() const;
    void recordMove(int fromX, int fromY, int toX, int toY);
    void setLastMove(int fromX, int fromY, int toX, int toY);

    // Вспомогательные методы для сохранения/загрузки
    void loadSavedGames();
    void saveSavedGames();
    QString serializePosition(const Position& pos) const;
    Position deserializePosition(const QString& data);
    QString getMoveHistoryJson() const;
    void setMoveHistoryFromJson(const QString& historyJson);
};
