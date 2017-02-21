import { Song } from './song.models'

export class Playlist {
    id: number;
    name: string;
    description: string;
    songs: Song[];
}
