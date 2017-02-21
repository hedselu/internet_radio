import { Component }                       from '@angular/core';
import { Angular2TokenService }            from 'angular2-token';
import { LocalStorageService }              from 'angular-2-local-storage';
import { Statistics } from '../models/statistics.models';
import { Playlist } from '../models/playlist.models';

@Component({
    selector: 'player',
    templateUrl: '../templates/player.component.html'
})
export class PlayerComponent{
    private statistics: Statistics;
    private selectedPlaylist: Playlist;
    private playlists: Playlist[];
    private playedPlaylistId; number;
    constructor(
        public _tokenService: Angular2TokenService,
        private localStorageService: LocalStorageService
    ) {
        this.playedPlaylistId = -1;
    }

    ngOnInit(): void {
        this.getStatistics();
        this.getPlaylistsFromStorage();
        if(this.playlists == null){
            this.getPlaylistsFromRemote();
        }
    }

    update(playlist: Playlist): void {
        this.select(playlist);
        this.playedPlaylistId = this.selectedPlaylist.id;
        this._tokenService.put( 'playlists/' + this.selectedPlaylist.id + '/player', {});
    }

    destroy(playlist: Playlist): void {
        this.select(playlist);
        this.playedPlaylistId = -1;
        this._tokenService.delete('playlists/' + this.selectedPlaylist.id + '/player');
    }

    select(playlist: Playlist): void {
        this.selectedPlaylist = playlist;
    }

    private getStatistics(): void {
        this._tokenService.get('statistics')
            .map(res => res.json() as Statistics)
            .subscribe(
                statistics => this.statistics = statistics,
                error => this.handleError(error)
            );
    }

    private getPlaylistsFromStorage(): void {
        var playlistsString = this.localStorageService.get('playlists');
        if(typeof playlistsString === 'string') {
            var playlistsJson = JSON.parse(playlistsString);
            this.playlists = playlistsJson as Playlist[];
        }
    }

    private getPlaylistsFromRemote(): void {
        this._tokenService.get('playlists')
            .map(res => res.json() as Playlist[])
            .subscribe(
                playlists => {
                    this.playlists = playlists;
                    var playlistsJson = JSON.stringify(this.playlists)
                    this.localStorageService.set('playlists', playlistsJson)
                },
                error => this.handleError(error)
            );
    }

    private handleError(error: any): Promise<any> {
        console.error('An error occurred', error);
        return Promise.reject(error.message || error);
    }
}
