import { DocumentBuilder } from 'firebase-functions/lib/providers/firestore';

export interface Game {
    id: number;
    status: GameStatus;
    teamOne: Map<string, any>;
    teamTwo: Map<string, any>;
    tournament: DocumentBuilder;
    type: GameType;
}

export enum GameStatus {
    NOT_STARTED = 'Not started',
    IN_PROGRESS = 'In progress',
    FINISHED = 'Finished',
}

export enum GameType {
    QUALIFIER = 'Qualifier',
    SEMI_FINAL = 'Semi final',
    FINAL = 'Final',
}